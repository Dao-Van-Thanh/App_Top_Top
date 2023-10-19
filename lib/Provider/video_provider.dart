import 'package:flutter/material.dart';

import '../Model/video_model.dart';

class VideoProvider extends ChangeNotifier {
  int countLike = 0;
  int countComment = 0;
  String caption = '';
  String profilePhoto = '';
  String username = '';
  String videoId = '';
  String authorId='';
  bool controlVideo = true;

  List<Color> iconColors = [Colors.white, Colors.white, Colors.white];
  bool hasCheckedLike = false;
  List<VideoModel> listVideo=[];
  void setValue(int countLikedata, int countCommentdata, String captiondata,
      String profilePhotodata, String usernamedata, String videoIddata,String authorIdData) {
    countLike = countLikedata;
    countComment = countCommentdata;
    caption = captiondata;
    profilePhoto = profilePhotodata;
    username = usernamedata;
    videoId = videoIddata;
    authorId = authorIdData;
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
  void changeControlVideo(){
    controlVideo = !controlVideo;
    notifyListeners();
  }
  void incrementComment() {
    countComment++;
    notifyListeners();
  }
}
