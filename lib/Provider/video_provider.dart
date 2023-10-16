import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  int countLike = 0;
  int countComment = 0;
  String caption = '';
  String profilePhoto = '';
  String username = '';
  String videoId = '';
  List<Color> iconColors = [Colors.white, Colors.white, Colors.white];
  bool hasCheckedLike = false;
  void setValue(int countLikedata, int countCommentdata, String captiondata,
      String profilePhotodata, String usernamedata, String videoIddata) {
    countLike = countLikedata;
    countComment = countCommentdata;
    caption = captiondata;
    profilePhoto = profilePhotodata;
    username = usernamedata;
    videoId = videoIddata;
  }

  void incrementLike() {
    if (iconColors[0] == Colors.white) {
      iconColors[0] = Colors.red;
      countLike += 1;
    } else {
      iconColors[0] = Colors.white;
      countLike -= 1;
    }
    notifyListeners();
  }
  void changeColor(){
    iconColors[0] = Colors.red;
    notifyListeners();
  }


  void incrementComment() {
    countComment++;
    notifyListeners();
  }
}
