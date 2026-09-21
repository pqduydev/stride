import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stride/auth/auth_cubit/auth_state.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/services/api_exception.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState());

  void resetErrors() {
    emit(
      state.copyWith(
        status: AuthStatus.initial,
        fieldErrors: {},
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> checkAuthStatus() async {
    // Khởi tạo thời gian delay chạy song song call API
    final minDelay = Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("access_token");
    final savedUser = await _authRepository.getSavedUser();
    if (isClosed) return;

    if (token != null && token.isNotEmpty && savedUser != null) {
      try {
        final updateInfo = await _authRepository.getUser();

        // Đợi nốt 1s
        await minDelay;

        emit(
          state.copyWith(status: AuthStatus.authenticated, user: updateInfo),
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
            errorMessage: 'Đã xãy ra lỗi không xác định',
          ),
        );
      }
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      final user = await _authRepository.login(
        username: username,
        password: password,
      );

      if (isClosed) return;

      if (isClosed) {
        return; // Khi người dùng thoát màn hình trong khi đợi response
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearErrorMessage: true,
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
          errorMessage: 'Đã xãy ra lỗi không xác định',
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
          errorMessage: 'Đã xãy ra lỗi không xác định',
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    try {
      await _authRepository.logout();

      if (isClosed) {
        return; // Khi người dùng thoát màn hình trong khi đợi response
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(const AuthState(status: AuthStatus.unauthenticated));
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
          errorMessage: 'Đã xãy ra lỗi không xác định',
        ),
      );
    }
  }

  void forceLogout() {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void resetStatus() {
    emit(state.copyWith(status: AuthStatus.initial, clearErrorMessage: true));
  }
}
