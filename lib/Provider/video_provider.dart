import 'package:flutter/material.dart';

import '../Model/video_model.dart';

class VideoProvider extends ChangeNotifier {
  int countLike = 0;
  int countComment = 0;
  int countSave = 0;
  String caption = '';
  String profilePhoto = '';
  String username = '';
  String videoId = '';
  String authorId='';
  String videoUrl ='';
  bool blockComments =false;
  bool controlVideo = true;
  List<Color> iconColors = [Colors.white, Colors.white, Colors.white];
  bool hasCheckedLike = false;
  bool hasCheckSave = false;
  bool hasFollowing = false;
  List<VideoModel> listVideo=[];

  void setHasFollowing(){
    hasFollowing = !hasFollowing;
    notifyListeners();
  }
  void setHasSave(){
    hasCheckSave = !hasCheckSave;
    notifyListeners();
  }
  void setValue(
      bool blockCommentsData,
      int countLikedata,
      int countCommentdata,
      int countSavedata,
      String captiondata,
      String profilePhotodata,
      String usernamedata,
      String videoIddata,
      String authorIdData,
      String videoUrlData,
      bool blockCommentData) {
    countLike = countLikedata;
    blockComments = blockCommentsData;
    countComment = countCommentdata;
    countSave = countSavedata;
    caption = captiondata;
    profilePhoto = profilePhotodata;
    username = usernamedata;
    videoId = videoIddata;
    authorId = authorIdData;
    videoUrl = videoUrlData;
    blockComments = blockCommentsData;
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
  void incrementSaveVideo() {
    if (iconColors[1] == Colors.white) {
      iconColors[1] = Colors.yellow;
      countSave += 1;
    } else {
      iconColors[1] = Colors.white;
      countSave -= 1;
    }
    notifyListeners();
  }

  void changeColor(){
    iconColors[0] = Colors.red;
    notifyListeners();
  }
  void changeColorSave(){
    iconColors[1] = Colors.yellow;

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
