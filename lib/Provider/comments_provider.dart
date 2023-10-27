import 'package:flutter/cupertino.dart';

class CommentsProvider extends ChangeNotifier{
  bool isEmojiPicker = false;
  bool reline = false;
  int count = 0;
  String id ='';
  bool showReComments = false;


  void onEmjiPicker(){
    isEmojiPicker = !isEmojiPicker;
    notifyListeners();
  }
  void checkRepline(bool check){
    reline = check;
    notifyListeners();
  }

  void setShowReComments(){
    showReComments = !showReComments;
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