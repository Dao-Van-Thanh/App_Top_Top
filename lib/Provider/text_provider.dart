import 'package:flutter/cupertino.dart';

class TextProvider extends ChangeNotifier{
  bool showSendReComment = false;
  bool showFullText = false;
  void isFullText(bool pressed) {
    showFullText = pressed;
    notifyListeners();
  }

  void setShowSendReComment(bool show){
    showSendReComment = show;
    notifyListeners();
  }
}