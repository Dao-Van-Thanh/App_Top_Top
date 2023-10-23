import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Provider/video_provider.dart';
import '../../Services/call_video_service.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final VideoProvider videoProvider;
  const VideoPlayerItem(this.videoUrl,this.videoId, this.videoProvider, {Key? key})
      : super(key: key);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isLoading = true;
  Duration watchedDuration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    Future.delayed(Duration(seconds: 5), () {
      CallVideoService().setView(widget.videoId);
    });
    videoPlayerController.initialize().then((_) {
      videoPlayerController.setVolume(1);
      videoPlayerController.play();
      videoPlayerController.setLooping(true);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(widget.videoProvider.controlVideo){
      videoPlayerController.play();
    }else{
      videoPlayerController.pause();
    }
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(videoPlayerController),
          if (isLoading)
            CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        ],
      ),
    );
  }
}
