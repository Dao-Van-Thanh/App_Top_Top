import 'package:flutter/material.dart';

class DangNhapSdtProvider extends ChangeNotifier{
  bool isChecked = false;
  String phone = '';
  void changeChecked(bool check){
    isChecked = check;
    notifyListeners();
  }

  void changePhone(String phone){
    this.phone = phone;
    notifyListeners();
  }
}