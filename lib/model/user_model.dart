class UserModel {
  final int? id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? accessToken;
  final String? refreshToken;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.accessToken,
    this.refreshToken,
  });

  // Chuẩn hóa chữ liệu nhận được
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }

  // Chuẩn hóa dữ liệu gửi đi
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
