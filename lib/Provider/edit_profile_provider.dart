import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier {
  String? _fullname;
  String? _idTopTop;

  String? _lib;
  // Getter cho thuộc tính fullname
  String? get getfullname => _fullname;

  // Setter cho thuộc tính fullname
  set setfullname(String? value) {
    _fullname = value;
  }

  // Getter cho thuộc tính idTopTop
  String? get getidTopTop => _idTopTop;

  // Setter cho thuộc tính idTopTop
  set setidTopTop(String? value) {
    _idTopTop = value;
  }

  // Getter cho thuộc tính lib
  String? get getlib => _lib;

  // Setter cho thuộc tính lib
  set setlib(String? value) {
    _lib = value;
  }

  void updateProfileData(String label, String value) {
    switch (label) {
      case 'Tên':
        setfullname = value;
        break;
      case 'Tiểu sử':
        setlib = value;
        break;
      case 'TikTok ID':
        setidTopTop = value;
        break;
      default:
        break;
    }
    notifyListeners(); // Thông báo cho UI biết rằng trạng thái đã thay đổi
  }
}
