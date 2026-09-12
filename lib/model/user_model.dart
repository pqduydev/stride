class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
