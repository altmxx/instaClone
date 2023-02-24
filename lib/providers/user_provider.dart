import 'package:flutter/material.dart';
import 'package:instaclone/resources/auth_methods.dart';
import '../model/user.dart' as model;
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User get getUser => _user!;

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
