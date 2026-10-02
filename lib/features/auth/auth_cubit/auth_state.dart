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
  final String? errorMessage;
  final Map<String, dynamic>? fieldErrors;
  final bool hasSeenPermission;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors,
    this.hasSeenPermission = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    List<UserModel>? users,
    String? errorMessage,
    Map<String, dynamic>? fieldErrors,
    bool? hasSeenPermission,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      hasSeenPermission: hasSeenPermission ?? this.hasSeenPermission,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    fieldErrors,
    hasSeenPermission,
  ];
}
