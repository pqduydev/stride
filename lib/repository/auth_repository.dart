import 'package:stride/model/user_model.dart';

class AuthRepository {
  final List<UserModel> _users = [];

  void addUser(UserModel user) async {
    await Future.delayed(
      Duration(seconds: 1),
    ); // Simulate a delay for adding the user
    _users.add(user);
  }
}
