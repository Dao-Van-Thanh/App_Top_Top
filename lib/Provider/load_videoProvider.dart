import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class LoadVideoProvider extends ChangeNotifier {
  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? get videoPlayer => _videoPlayerController;

  set videoPlayer(VideoPlayerController? videoPlayer){
    _videoPlayerController = videoPlayer;
    notifyListeners();
  }

  bool _loadingVD = false;
  bool get loadingVD => _loadingVD;
  set loadingVD(bool val){
    _loadingVD = val;
    notifyListeners();
  }

  void loadVideoPlayer(String videoUrl) async{
    print('loadvideo tiếp theo$videoUrl');
    loadingVD = true;
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    loadingVD = false;
  }
  void disposeAd() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }
}