import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/repository/user_repository.dart';
import 'package:stride/services/api_exception.dart';
import 'package:stride/features/user/user_cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(const UserState());

  void resetStatus() {
    emit(state.copyWith(status: UserStatus.initial, clearErrorMessage: true));
  }

  void resetErrors() {
    emit(
      state.copyWith(
        status: UserStatus.initial,
        fieldErrors: {},
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> changedFields) async {
    // Nếu không có trường nào thay đổi thì không call API
    if (changedFields.isEmpty) {
      emit(state.copyWith(status: UserStatus.success));
      return;
    }

    emit(state.copyWith(status: UserStatus.loading, clearErrorMessage: true));

    try {
      final updatedUser = await _userRepository.updateProfile(changedFields);

      if (isClosed) return;

      emit(state.copyWith(status: UserStatus.success, user: updatedUser));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: 'Đã xảy ra lỗi không xác định',
        ),
      );
    }
  }

  Future<void> changePassword(Map<String, dynamic> updatePassword) async {
    emit(state.copyWith(status: UserStatus.loading, clearErrorMessage: true));

    try {
      await _userRepository.changePassword(updatePassword);

      if (isClosed) return;

      emit(state.copyWith(status: UserStatus.success, clearErrorMessage: true));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: 'Đã xảy ra lỗi không xác định',
        ),
      );
    }
  }
}
