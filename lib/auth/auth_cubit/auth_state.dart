import 'package:equatable/equatable.dart';
import 'package:stride/model/user_model.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final List<UserModel> users;
  final String? errorMessage;
  final Map<String, dynamic>? fieldErrors; // Thêm trường lưu lỗi từng field

  const AuthState({
    this.status = AuthStatus.initial,
    this.users = const [],
    this.errorMessage,
    this.fieldErrors,
  });

  AuthState copyWith({
    AuthStatus? status,
    List<UserModel>? users,
    String? errorMessage,
    Map<String, dynamic>? fieldErrors,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      fieldErrors: clearErrorMessage ? null : fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage, fieldErrors];
}
