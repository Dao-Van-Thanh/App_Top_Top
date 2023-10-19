
import 'package:flutter/cupertino.dart';

class ChatsProfiver extends ChangeNotifier{
    int check = 0;
    void setCheck(int i){
      check = i;
      notifyListeners();
    }
}