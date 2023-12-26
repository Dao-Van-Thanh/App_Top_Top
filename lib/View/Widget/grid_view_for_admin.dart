import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Model/video_model.dart';
import '../../Provider/page_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Services/call_video_service.dart';
import '../../Services/tab_video_service.dart';
import '../Pages/Admin/man_hinh_manager_video_by_admin.dart';
import '../Pages/Others/man_hinh_video_bookmart.dart';
import '../Pages/Others/man_hinh_video_by_author.dart';

class GridViewVideoForAdmin extends StatefulWidget {
  String uid;
  String label;
  PageProvider pageProvider;
  GridViewVideoForAdmin(this.uid, this.label, this.pageProvider, {super.key});

  @override
  State<GridViewVideoForAdmin> createState() => _GridViewVideoForAdminState();
}

class _GridViewVideoForAdminState extends State<GridViewVideoForAdmin> {
  ChewieController? controller;
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

  _showDialogError(context, String videoId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Bỏ ẩn video này?',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
            ),
            TextButton(
              onPressed: () {
                CallVideoService().publicVideo(videoId);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text(
                'bỏ',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _content2(BuildContext context, List<VideoModel> videos) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
              if (video.status == false) {
                _showDialogError(context, video.id);
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.label == 'videoPublic'
                      ? ManHinhManagerVideoByAdmin(
                          uid: video.uid, index: index, status: video.status)
                      : (widget.label == 'TabVideo'
                          ? ManhinhVideoByAuthor(uid: video.uid, index: index)
                          : ManHinhVideoByBookMart(index: index)),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomRight,
                children: [
                  video.status == false
                      ? Container(
                          margin: const EdgeInsets.only(
                              top: 3, left: 13, right: 13, bottom: 3),
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(video.videoUrl),
                                  fit: BoxFit.cover)),
                        )
                      : Chewie(
                          controller: ChewieController(
                            videoPlayerController:
                                VideoPlayerController.network(
                              video.videoUrl,
                            ),
                            autoPlay: false, // Tắt tự động phát video
                            looping: true, // Cho phép lặp lại video
                            allowMuting: true, // Cho phép tắt tiếng
                            showControls: false, // Tắt hiển thị các điều khiển
                            showOptions:
                                false, // Tắt hiển thị tùy chọn video (chẳng hạn như tua video)
                            aspectRatio: 0.7, // Tùy chỉnh tỷ lệ khung hình
                            autoInitialize:
                                true, // Tự động khởi tạo videoPlayerController khi được tạo
                            errorBuilder: (context, errorMessage) {
                              // Xử lý lỗi video (nếu có)
                              return Center(
                                child: Text('Lỗi: $errorMessage'),
                              );
                            },
                            placeholder: const Center(
                              child:
                                  CircularProgressIndicator(), // Hiển thị chỉ báo tải video
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.play_arrow, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          "${video.views.toString()} ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
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
    Future<List<VideoModel>> result;
    if (widget.label == 'videoPublic') {
      result = TabVideoService.getVideosByUid(widget.uid);
    } else {
      result = TabVideoService.getVideoPrivate(widget.uid);
    }
    return FutureBuilder<List<VideoModel>>(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Không có dữ liệu'),
          );
        } else {
          return _content2(context, snapshot.data!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: _getDataFirebase(context));
  }
}
