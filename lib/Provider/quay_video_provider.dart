import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class QuayVideoProvider extends ChangeNotifier{
  XFile? videoFile;

  void setVideoFile(XFile videoFile){
    this.videoFile = videoFile;
    notifyListeners();
  }
}