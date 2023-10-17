import 'package:flutter/cupertino.dart';

class EmojiProvider extends ChangeNotifier{
  bool isEmojiPicker = false;
  void onEmjiPicker(){
    isEmojiPicker != isEmojiPicker;
    notifyListeners();
  }
}