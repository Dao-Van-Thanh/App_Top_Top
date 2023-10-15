import 'dart:io';
import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_dang_video.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class ManHinhKiemTraVideo extends StatefulWidget {
  final XFile file;

  ManHinhKiemTraVideo(this.file);

  @override
  State<ManHinhKiemTraVideo> createState() => _ManHinhKiemTraVideoState();
}

class _ManHinhKiemTraVideoState extends State<ManHinhKiemTraVideo> {
  VideoPlayerController? videoController;
  late QuayVideoProvider provider = Provider.of<QuayVideoProvider>(context);
  Future<bool> _showCancelDialog() async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác định hủy bỏ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );
    return result ?? false; // Trả về true nếu result là null
  }

  // Future<void> downloadVideo(XFile videoFile) async {
  //   File file = File(videoFile.path);
  //   final directory = await getExternalStorageDirectory();
  //   final savedDir = directory?.path;
  //
  //   if (savedDir != null) {
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: file.path,  // Đặt URL cho việc tải xuống
  //       savedDir: savedDir,   // Thư mục lưu trữ tải xuống
  //       fileName: 'downloaded_video.mp4',  // Đặt tên cho file tải xuống
  //       showNotification: true,  // Hiển thị thông báo khi tải xuống hoàn thành
  //       openFileFromNotification: true,  // Mở file sau khi tải xuống xong
  //     );
  //     // taskId chứa thông tin về tác vụ tải xuống, bạn có thể sử dụng nó để kiểm tra trạng thái tải xuống.
  //   }
  // }

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.file(File(widget.file.path));
    videoController?.play();
    // Đảm bảo rằng video đã được khởi tạo trước khi thực hiện thao tác
    videoController!.initialize().then((_) {
      // Đặt video để lặp lại
      videoController!.setLooping(true);
      // Đảm bảo video đã được khởi tạo trước khi chơi
      if (mounted) {
        setState(() {}); // Kích hoạt lại build để hiển thị video
      }
    });
  }

  @override
  void dispose() {
    videoController?.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: _Content(context),
                    flex: 9,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  // downloadVideo(widget.file);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                child: Text('Tải xuống'),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  videoController?.dispose(); // Giải phóng tài nguyên
                                  Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (context) =>
                                                ManHinhDangVideo(widget.file),));
                                },
                                child: Text('Tiếp'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.pinkAccent)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () async {
                    bool cancel = (await _showCancelDialog()) as bool;
                    if (cancel) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Content(BuildContext context) {
    if (videoController != null && videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        ),
      );
    } else {
      return const Center(
        child: Text('Không có video để hiển thị'),
      );
    }
  }
}
