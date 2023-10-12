import 'package:flutter/material.dart';

class DangKyEmailProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;
  String? emailErrorText;
  bool isClearButtonVisible = false;
  bool isEmailValid(String text) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegExp.hasMatch(text);
  }

  void updateButtonStatus(bool isEnabled) {
    isButtonEnabled = isEnabled;
    notifyListeners();
  }

  bool validateEmail() {
    emailErrorText =
        isEmailValid(emailController.text) ? null : 'Nhập địa chỉ email hợp lệ';
    notifyListeners();
    return emailErrorText == null;
  }
}
