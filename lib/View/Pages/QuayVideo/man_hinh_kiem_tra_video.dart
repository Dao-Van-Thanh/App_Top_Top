import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ManHinhKiemTraVideo extends StatefulWidget {
  final XFile file;

  ManHinhKiemTraVideo(this.file);

  @override
  State<ManHinhKiemTraVideo> createState() => _ManHinhKiemTraVideoState();
}

class _ManHinhKiemTraVideoState extends State<ManHinhKiemTraVideo> {
  VideoPlayerController? videoController;

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

  Future<void> downloadVideo(File videoFile) async {
    print('đã vào');
    final directory = await getExternalStorageDirectory();
    final savedDir = directory?.path; // Lấy thư mục lưu trữ trên thiết bị

    if (savedDir != null) {
      final taskId = await FlutterDownloader.enqueue(
        url: '',
        // Đặt URL của video bạn muốn tải về
        savedDir: savedDir,
        // Thư mục lưu video trên thiết bị
        fileName: widget.file.name,
        // Tên của file video
        showNotification: true,
        // Hiển thị thông báo khi tải xuống hoàn thành
        openFileFromNotification: true, // Mở file sau khi tải xuống xong
      );
      // taskId chứa thông tin về tác vụ tải xuống
      // Bạn có thể sử dụng taskId để theo dõi tình trạng tải xuống hoặc quản lý các tác vụ khác liên quan đến tải xuống.
    }
  }

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
                                  print('abc');
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
                                  print('acsacscscs');
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
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  bool cancel = (await _showCancelDialog()) as bool;
                  print(cancel);
                  if (cancel) {
                    Navigator.of(context).pop();
                  }
                },
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
