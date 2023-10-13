import 'package:flutter/material.dart';

class EditItemProfileProvider extends ChangeNotifier {
  TextEditingController textController = TextEditingController();
  Color colorText = Colors.black;
  int maxText = 0;

  int maxLine = 5;
  String? label;
  TextEditingController get getTextController => textController;
  String? get getLabel => label;
  int countText = 0;
  int? get getcountText => countText;
  int? get getMaxText => maxText;
  int? get getMaxLine => maxLine;

  updateProfileData(String newlabel, String newvalue) {
    label = newlabel;
    textController.text = newvalue;
    switch (label) {
      case 'Tên':
        maxText = 30;
        maxLine = 1;
        break;
      case 'Tiểu sử':
        maxText = 80;
        maxLine = 5;
        break;
      case 'TikTok ID':
        maxText = 20;
        maxLine = 1;
        break;
      default:
    }
    updateCountText(textController.text);
    notifyListeners();
  }

  updateCountText(String text) {
    countText = text.length;
    countText = countText > maxText ? --countText : countText;
    colorText = countText == maxText ? Colors.red : Colors.black;
    notifyListeners();
  }
}
