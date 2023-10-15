import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/user.dart';
import 'package:instagram_clone/Resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod authMethods = AuthMethod();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User? user = await authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
