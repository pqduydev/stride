import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/auth/auth_cubit/auth_state.dart';
import 'package:stride/model/user_model.dart';
import 'package:stride/repository/auth_repository.dart';

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

      emit(
        state.copyWith(
          status: AuthStatus.success,
          users: [...state.users, newUser],
        ),
      );
    } catch (e) {
      if (e is Map) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            fieldErrors: Map<String, dynamic>.from(e),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: e.toString().replaceAll('Exception: ', ''),
          ),
        );
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    // emit(state.copyWith(status: AuthStatus.loading, clearErrorMessage: true));

    // try {
    //   final localUserIndex = state.users.indexWhere(
    //     (u) => u.email == email && u.password == password,
    //   );

    //   UserModel user;
    //   if (localUserIndex != -1) {
    //     await Future.delayed(const Duration(seconds: 1));
    //     user = state.users[localUserIndex];
    //   } else {
    //     user = await _authRepository.login(email: email, password: password);
    //   }

    //   final updatedUsers = List<UserModel>.from(state.users);
    //   if (!updatedUsers.any((u) => u.username == user.username)) {
    //     updatedUsers.add(user);
    //   }

    //   emit(state.copyWith(status: AuthStatus.success, users: updatedUsers));
    // } catch (e) {
    //   emit(
    //     state.copyWith(
    //       status: AuthStatus.failure,
    //       errorMessage: e.toString().replaceAll('Exception: ', ''),
    //     ),
    //   );
    // }
  }

  void resetStatus() {
    emit(state.copyWith(status: AuthStatus.initial, clearErrorMessage: true));
  }
}
