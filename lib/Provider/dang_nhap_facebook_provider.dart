import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DangNhapFacebookProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }
}
