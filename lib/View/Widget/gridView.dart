import 'dart:async';
import 'dart:typed_data';
import 'package:app/Model/video_model.dart';
import 'package:app/Provider/profile_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Services/tab_video_service.dart';
import '../Pages/Others/man_hinh_video_by_author.dart';
import '../Pages/TrangChu/danh_cho_ban.dart';

class GridViewVideo extends StatefulWidget {
  String uid;
  GridViewVideo(this.uid);

  @override
  _GridViewVideoState createState() => _GridViewVideoState();
}

class _GridViewVideoState extends State<GridViewVideo> {
  bool _isLooping = false; // Đặt mặc định để lặp lại
  ChewieController? controller ;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    if (!provider.isLoading && provider.videos.isEmpty) {
      provider.loadVideos(widget.uid);
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
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        primary: false,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return InkWell(
            onTap: () {
              print('${video.id}');
              print('${video.uid}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManhinhVideoByAuthor(uid: video.uid,),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomRight,
                children: [
                  // Sử dụng Chewie để phát video thay vì VideoPlayer
                  Chewie(
                    controller: ChewieController(
                      videoPlayerController: VideoPlayerController.network(
                        video.videoUrl,
                      ),
                      autoPlay: false, // Tắt tự động phát video
                      looping: true, // Cho phép lặp lại video
                      allowMuting: true, // Cho phép tắt tiếng
                      showControls: false, // Tắt hiển thị các điều khiển
                      showOptions: false, // Tắt hiển thị tùy chọn video (chẳng hạn như tua video)
                      aspectRatio: 0.7, // Tùy chỉnh tỷ lệ khung hình
                      autoInitialize: true, // Tự động khởi tạo videoPlayerController khi được tạo
                      errorBuilder: (context, errorMessage) {
                        // Xử lý lỗi video (nếu có)
                        return Center(
                          child: Text('Lỗi: $errorMessage'),
                        );
                      },
                    ),
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

      ),
    );
  }

  Widget _getDataFirebase(BuildContext context) {
    return FutureBuilder<List<VideoModel>>(
      future: TabVideoService.getVideosByUid(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('');
        }
        return _content2(context, snapshot.data!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getDataFirebase(context)
    );
  }
}
