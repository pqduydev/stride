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

  void checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (isClosed) return;

    final token = prefs.getString("access_token");
    final savedUser = await _authRepository.getSavedUser();

    if (token != null && token.isNotEmpty && savedUser != null) {
      emit(state.copyWith(status: AuthStatus.authenticated, user: savedUser));
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
          errorMessage: e.toString().replaceAll('Exception: ', ''),
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
      final newUser = await _authRepository.register(
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

      emit(
        state.copyWith(
          status: AuthStatus.success,
          users: [...state.users, newUser],
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
          errorMessage: e.toString().replaceAll('Exception: ', ''),
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
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            clearErrorMessage: true,
          ),
        );
      }
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: AuthStatus.initial, clearErrorMessage: true));
  }
}
