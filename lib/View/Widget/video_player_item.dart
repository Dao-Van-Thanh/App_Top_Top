import 'package:app/Provider/music_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../Provider/load_videoProvider.dart';
import '../../Provider/video_provider.dart';
import '../../Services/call_video_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String songUrl;
  final VideoProvider videoProvider;
  const VideoPlayerItem(this.videoUrl,this.videoId, this.videoProvider, this.songUrl, {Key? key})
      : super(key: key);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController? videoPlayerController;
  late MusicProvider? musicProvider;
  late ChewieController chewieController;
  bool isLoading = true;
  bool isPlay = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    final loadVideoProvider = context.read<LoadVideoProvider>();
    videoPlayerController = loadVideoProvider.videoPlayer;
    if (videoPlayerController == null) {
      videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    }
    _initializeVideoPlayer();
  }
  void _initializeVideoPlayer() async{
    if (videoPlayerController != null) {
      videoPlayerController!.initialize().then((_) {
        videoPlayerController!.setVolume(1);
        videoPlayerController!.play();
        videoPlayerController!.setLooping(true);
        setState(() {
          isLoading = false;
        });
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    videoPlayerController!.dispose();
  }
  int count =0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    if(widget.songUrl.length>0 && musicProvider.isCheckMusicPlay==false){
      musicProvider.initAudioPlayerForScreenVideo(widget.songUrl);
      musicProvider.setIsCheckMusicPlay();
    }
      return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onLongPress: () {
          _showDialog(context);
        },
        onTap: () {
          widget.videoProvider.changeControlVideo();
          if(widget.videoProvider.controlVideo == true){
            videoPlayerController!.play();
            if(widget.songUrl.length>0){
              musicProvider.playAudio();
            }
          }else {
            videoPlayerController!.pause();
            if(widget.songUrl.length>0){
              musicProvider.pauseAudio();
            }
          }
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(videoPlayerController!),
              if (isLoading)
                CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              widget.videoProvider.controlVideo == false
                  ? Icon(Icons.play_circle_filled, size: 50, color: Colors.white.withOpacity(0.5))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Tải video xuống'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // _showDialog2(context);
                Navigator.of(context).pop();
                _showDialog2(context);

              },
              child:_isSuccess==false?Text('OK'):CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  _showDialog2(context) async{

    Future.delayed(Duration(seconds: 3), (){
      setState(() async{
        await downloadFile();
        Navigator.of(context).pop();
      });
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Đang tải video xuống'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  _isSuccess = true;
                });
              },
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
  final snackBar = SnackBar(
    content: Text('Tải thành công!!!'),
    action: SnackBarAction(
      label: 'Đóng',
      onPressed: () {
        // Xử lý khi người dùng nhấn vào nút đóng
      },
    ),
  );
  Future downloadFile() async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${widget.videoProvider.caption}.mp4';
    await Dio().download(widget.videoUrl, path);
    bool? isSaved = await GallerySaver.saveVideo(path, toDcim: true);
  }
}
