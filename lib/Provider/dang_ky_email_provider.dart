import 'package:flutter/material.dart';

class DangKyEmailProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;
  String? emailErrorText;
  bool isClearButtonVisible = false;
  bool _isEmailValid(String text) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(text);
  }

  void updateButtonStatus(bool isEnabled) {
    isButtonEnabled = isEnabled;
    notifyListeners();
  }

  bool validateEmail() {
    emailErrorText = _isEmailValid(emailController.text)
        ? null
        : 'Nhập địa chỉ email hợp lệ';
    notifyListeners();
    return emailErrorText == null;
  }
}
