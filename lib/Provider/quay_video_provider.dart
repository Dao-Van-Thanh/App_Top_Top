import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class QuayVideoProvider extends ChangeNotifier{
  XFile? videoFile;
  bool isChecked = true;
  bool isControlMusic = false;

  void setVideoFile(XFile videoFile){
    this.videoFile = videoFile;

    notifyListeners();
  }
  void setChecked(){
    isChecked = !isChecked!;
    notifyListeners();
  }

  void setControlMusic(){
    isControlMusic = !isControlMusic!;
    notifyListeners();
  }

}