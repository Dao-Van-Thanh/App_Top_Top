import 'package:flutter/material.dart';
import 'package:app/Model/video_model.dart';
import 'package:app/Services/tab_video_service.dart';


class ProfileProvider with ChangeNotifier {
  List<VideoModel> _videos = [];
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  String isSearch = '';
  bool _isAdmin = false;
  bool _isBan = false;

  List<VideoModel> get videos => _videos;
  bool get isLoading => _isLoading;
  bool get isAdmin => _isAdmin;
  bool get ban => _isBan;

  void banUser(){
    _isBan = !_isBan;
    notifyListeners();
  }

  void updateRoles(bool checkRoles){
    _isAdmin = checkRoles;
    notifyListeners();
  }
  void setVideos(List<VideoModel> list){
    _videos = list;
    notifyListeners();
  }

  Future<void> loadVideos(String uid) async {
    _isLoading = true;
    _videos = await TabVideoService.getVideosByUid(uid);
    _isLoading = false;
    notifyListeners();
  }
  void setSearch(TextEditingController checkSearch){
    searchController = checkSearch;
    notifyListeners();
  }
}
