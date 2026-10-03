// ignore_for_file: slash_for_doc_comments

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/model/user_model.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/services/api_exception.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final Future<void> Function()? _beforeLogout;

  static const _keyHasSeenPermission = "has_seen_permission";

  AuthCubit(this._authRepository, {this._beforeLogout})
    : super(const AuthState());

  void resetErrors() {
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        fieldErrors: {},
        clearErrorMessage: true,
      ),
    );
  }

  // Kiểm tra & đồng bộ cờ xin quyền dựa trên cài đặt hệ điều hành
  Future<bool> _resolvePermissionState(SharedPreferences prefs) async {
    // 1. Lấy cờ từ SharedPreferences (Lúc này là false nếu vừa logout)
    bool hasSeenPermission = prefs.getBool(_keyHasSeenPermission) ?? false;

    // 2. Nếu cờ trong app đang là false, ta check thực tế hệ điều hành
    if (!hasSeenPermission) {
      final isCameraGranted = await Permission.camera.isGranted;
      final isNotificationGranted = await Permission.notification.isGranted;

      // Nếu OS đã cấp quyền từ lần xài trước, ta cập nhật lại cờ
      if (isCameraGranted && isNotificationGranted) {
        hasSeenPermission = true;
        await prefs.setBool(_keyHasSeenPermission, true);
      }
    }
    return hasSeenPermission;
  }

  Future<void> checkAuthStatus() async {
    // Khởi tạo thời gian delay chạy song song call API
    final minDelay = Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final savedUser = await _authRepository.getSavedUser();

    final hasSeenPermission = await _resolvePermissionState(prefs);

    if (isClosed) return;

    if (token != null && token.isNotEmpty && savedUser != null) {
      try {
        final updateInfo = await _authRepository.getUser();

        if (isClosed) return;

        // Đợi nốt 1s
        await minDelay;

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: updateInfo,
            hasSeenPermission: hasSeenPermission,
          ),
        );
      } catch (_) {
        // Kiểm tra trước khi emit trong catch
        if (isClosed) return;

        // Khi token khởi tạo hết hạn hoặc lỗi API -> Đưa về unauthenticated và dọn sạch error message
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            fieldErrors: {},
            clearErrorMessage: true,
            hasSeenPermission: hasSeenPermission,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          hasSeenPermission: hasSeenPermission,
        ),
      );
    }
  }

  // Đánh dấu đã hoàn thành bước xin quyền Onboarding
  Future<void> completePermissionOnboarding() async {
    await _authRepository.setHasSeenPermissionScreen(true);
    emit(state.copyWith(hasSeenPermission: true));
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      await _authRepository.login(username: username, password: password);

      if (isClosed) {
        return; // Khi người dùng thoát màn hình trong khi đợi response
      }

      // Gọi API lấy đầy đủ thông tin người dùng
      final fullUser = await _authRepository.getUser();

      if (isClosed) return;

      final prefs = await SharedPreferences.getInstance();
      final hasSeenPermission = await _resolvePermissionState(prefs);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: fullUser,
          clearErrorMessage: true,
          hasSeenPermission: hasSeenPermission,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.statusCode == 401
              ? {
                  "username": ["Tên đăng nhập hoặc mật khẩu không chính xác"],
                  "password": ["Tên đăng nhập hoặc mật khẩu không chính xác"],
                }
              : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Đã xảy ra lỗi không xác định',
        ),
      );
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String passwordConfirm,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );

      if (isClosed) {
        return; // Khi người dùng thoát màn hình trong khi đợi response
      }

      emit(state.copyWith(status: AuthStatus.success));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Đã xảy ra lỗi không xác định',
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      /* Gọi callback trước khi logout, Ví dụ thực hiện hủy FCM Device Token ở 
      Backend (cần assess token) trước khi xoá access token ở local */
      _beforeLogout?.call();
      await _authRepository.logout();

      if (isClosed) {
        return; // Khi người dùng thoát màn hình trong khi đợi response
      }

      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          hasSeenPermission: false,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Đã xảy ra lỗi không xác định',
        ),
      );
    }
  }

  Future<void> forceLogout() async {
    await _authRepository.clearLocalData();

    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
        hasSeenPermission: false,
      ),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: AuthStatus.initial, clearErrorMessage: true));
  }

  /** Hiện đang được gọi từ personal_information_screen 
  để đồng bộ dữ liệu sau khi cập nhật */
  void updateUserInMemory(UserModel updatedUser) {
    emit(state.copyWith(user: updatedUser));
  }
}
