import 'package:flutter/material.dart';

class MyData with ChangeNotifier {
  String _email = '';
  String _password = '';
  String get email => _email;
  String get password => _password;

  void updateEmail(String newData) {
    _email = newData;
    notifyListeners();
  }
    void updatePass(String newData) {
    _password = newData;
    notifyListeners();
  }
}
