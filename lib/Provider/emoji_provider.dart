import 'package:flutter/cupertino.dart';

class EmojiProvider extends ChangeNotifier{
  bool isEmojiPicker = false;
  bool reline = false;
  int count = 0;
  String id ='';
  void onEmjiPicker(){
    isEmojiPicker = !isEmojiPicker;
    notifyListeners();
  }
  void checkRepline(bool check){
    reline = check;
    notifyListeners();
  }


  void setCoutToZero(){
    count = 0;
    notifyListeners();
  }
  void setCmt(String s){
    id = s;
    notifyListeners();
  }
}