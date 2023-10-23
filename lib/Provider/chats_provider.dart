
import 'package:flutter/cupertino.dart';

class ChatsProfiver extends ChangeNotifier{
    int check = 0;
    bool emojiShowing = false;
    void setEmojiShowing(bool check){
      emojiShowing = check;
      notifyListeners();
    }
    void setCheck(int i){
      check = i;
      notifyListeners();
    }
}