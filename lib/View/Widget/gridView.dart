import 'dart:async';
import 'dart:typed_data';
import 'package:app/Model/video_model.dart';
import 'package:app/Provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Services/tab_video_service.dart';

class GridViewVideo extends StatefulWidget {
  @override
  _GridViewVideoState createState() => _GridViewVideoState();
}

class _GridViewVideoState extends State<GridViewVideo> {
  late VideoPlayerController _controller;
  bool _isLooping = false; // Đặt mặc định để lặp lại

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    if (!provider.isLoading && provider.videos.isEmpty) {
      provider.loadVideos();
    }
  }

  Future<Uint8List?> getThumbnail(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxWidth: 100, // Độ rộng ảnh thumbnail
      quality: 25, // Chất lượng ảnh (0 - 100)
    );
    return uint8list;
  }

  Widget _content2(BuildContext context, List<VideoModel> videos) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      padding: EdgeInsets.all(20),
      primary: false,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return InkWell(
          onTap: () {
            print('${video.id}');
          },
          child: Container(
            color: Colors.black,
            margin: EdgeInsets.all(2),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomRight,
              children: [
                VideoPlayer(
                  _createVideoPlayerController(video.videoUrl),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  child: Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        "${video.views.toString()} ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  VideoPlayerController _createVideoPlayerController(String videoUrl) {
    final controller = VideoPlayerController.network(videoUrl);
    controller.setLooping(_isLooping);
    // Đặt thời gian ban đầu cho video (2 giây)
    controller.initialize().then((_) {
      controller.seekTo(Duration(seconds: 2));
      controller.play();
    });
    return controller;
  }

  Widget _getDataFirebase(BuildContext context, provider) {
    return FutureBuilder<List<VideoModel>>(
      future: TabVideoService.getVideosByUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Không có video nào.');
        }
        provider.setVideos(snapshot.data!);
        return _content2(context, snapshot.data!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.videos.isEmpty) {
            return _getDataFirebase(context, provider);
          }
          return _content2(context, provider.videos);
        },
      ),
    );
  }
}
