import 'package:flutter/cupertino.dart';

class TextProvider extends ChangeNotifier{
  bool showFullText = false;
  void isFullText() {
    showFullText = !showFullText;
    notifyListeners();
  }
}