import 'package:equatable/equatable.dart';
import 'package:stride/model/user_model.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final UserModel? user;
  final String? errorMessage;
  final Map<String, dynamic>? fieldErrors;

  const UserState({
    this.status = UserStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors,
  });

  UserState copyWith({
    UserStatus? status,
    UserModel? user,
    String? errorMessage,
    Map<String, dynamic>? fieldErrors,
    bool clearErrorMessage = false,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, fieldErrors];
}