import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;
  String get username => _username;

  void loginUser({
    required bool isAdmin,
    required String username,
  }) {
    _isLoggedIn = true;
    _isAdmin = isAdmin;
    _username = username;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isAdmin = false;
    _username = '';
    notifyListeners();
  }
}

