import 'package:app/Services/dang_nhap_google_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DangNhapGooogleProvider extends ChangeNotifier {
  final LoginGoogleService _dangNhapGooogleServiceService =
      LoginGoogleService();
  User? _user;

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    _user = await _dangNhapGooogleServiceService.signInWithGoogle();
    if (_user == null) return;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _dangNhapGooogleServiceService.signOut();
    _user = null;
    notifyListeners();
  }
}
