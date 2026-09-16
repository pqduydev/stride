import 'package:equatable/equatable.dart';
import 'package:stride/model/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failure,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final List<UserModel> users;
  final String? errorMessage;
  final Map<String, dynamic>? fieldErrors;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.users = const [],
    this.errorMessage,
    this.fieldErrors,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    List<UserModel>? users,
    String? errorMessage,
    Map<String, dynamic>? fieldErrors,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      users: users ?? this.users,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, user, users, errorMessage, fieldErrors];
}
