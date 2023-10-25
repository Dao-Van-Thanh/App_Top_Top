import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_kiem_tra_video.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManHinhQuayVideo extends StatefulWidget {
  @override
  _ManHinhQuayVideoState createState() => _ManHinhQuayVideoState();
}

class _ManHinhQuayVideoState extends State<ManHinhQuayVideo> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false; // Biến trạng thái quay video

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller cho camera
    _controller = CameraController(
      const CameraDescription(
        name: '0', // Sử dụng camera sau (back camera)
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
      ResolutionPreset.high, // Chất lượng video
    );

    // Khởi tạo controller và chờ nó sẵn sàng
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Giải phóng resources khi không cần sử dụng camera nữa và đảm bảo dừng quay video (nếu đang quay)
    if (_controller.value.isRecordingVideo) {
      _controller.stopVideoRecording();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    XFile videoFile;

    return Consumer<QuayVideoProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(36)),
                    clipBehavior: Clip.antiAlias,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Camera đã sẵn sàng, hiển thị nó trong widget CameraPreview
                          return CameraPreview(_controller);
                        } else {
                          // Đợi camera sẵn sàng
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 70,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () async {
                            try {
                              if (_isRecording) {
                                // Đã đang quay video, dừng lại
                                videoFile = await _controller.stopVideoRecording();
                                provider.setVideoFile(videoFile);
                                // Ở đây, bạn có thể làm gì đó với videoFile, ví dụ: lưu hoặc chia sẻ video
                                setState(() {
                                  _isRecording = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManHinhKiemTraVideo(videoFile),
                                    )
                                );
                              } else {
                                // Bắt đầu quay video
                                await _controller.startVideoRecording();

                                setState(() {
                                  _isRecording = true;
                                });
                              }
                            } catch (e) {
                              print("Lỗi khi quay video: $e");
                            }
                          },
                          icon: Icon(
                            _isRecording ? Icons.stop : Icons.camera_alt,
                            size: 50,
                          ),
                          // fill: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: 50,
                        // color: Colors.yellow,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                XFile? file = await pickVideo();
                                provider.setVideoFile(file!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManHinhKiemTraVideo(file),
                                    )
                                );
                              },
                              icon: const Icon(
                                Icons.folder,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Tải lên',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
    );

  }
  Future<XFile?> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final PlatformFile file = result.files.single;
      return XFile(file.path!);
    }
    return null;
  }
}
