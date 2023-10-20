import 'package:flutter/cupertino.dart';

class EmojiProvider extends ChangeNotifier{
  bool isEmojiPicker = false;
  bool reline = false;
  String id ='';
  void onEmjiPicker(){
    isEmojiPicker = !isEmojiPicker;
    notifyListeners();
  }
  void checkRepline(bool check){
    reline = check;
    notifyListeners();
  }
  void setCmt(String s){
    id = s;
    notifyListeners();
  }
}