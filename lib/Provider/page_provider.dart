

import 'package:flutter/cupertino.dart';

class PageProvider with ChangeNotifier {
  int page = 0;

  void setPageProfile(){
    page = 4;
    notifyListeners();
  }
  void setPage(int index){
    page = index;
    notifyListeners();
  }
}
