import 'package:flutter/material.dart';
import 'package:app/Model/video_model.dart';
import 'package:app/Services/tab_video_service.dart';

class ProfileProvider with ChangeNotifier {
  List<VideoModel> _videos = [];
  bool _isLoading = false;

  List<VideoModel> get videos => _videos;
  bool get isLoading => _isLoading;


  void setVideos(List<VideoModel> list){
    _videos = list;
    notifyListeners();
  }

  Future<void> loadVideos() async {
    _isLoading = true;
    _videos = await TabVideoService.getVideosByUid();
    _isLoading = false;
    notifyListeners();
  }
}
