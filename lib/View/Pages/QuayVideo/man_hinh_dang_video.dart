import 'dart:io';

import 'package:app/Provider/quay_video_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart'; // Import thư viện video_player

class ManHinhDangVideo extends StatefulWidget {
  final XFile xflie;

  ManHinhDangVideo(this.xflie);

  @override
  _ManHinhDangVideoState createState() => _ManHinhDangVideoState();
}

class _ManHinhDangVideoState extends State<ManHinhDangVideo> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.xflie.path))
      ..initialize().then((_) {
        setState(() {}); // Kích hoạt lại build để hiển thị video
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuayVideoProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Đăng',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: const TextField(
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                hintText: 'Viết nội dung video của bạn ở đây',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            padding: EdgeInsets.all(13),
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black12,
                              width: 1
                          )
                      ),
                    ),
                    Container(
                      height: 70,
                      color: Colors.pink,
                    ),
                    Container(
                      height: 70,
                      color: Colors.yellow,
                    ),
                    Container(
                      height: 70,
                      color: Colors.green,
                    ),
                  ],
                ),
                Positioned(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                  ),
                ),
              ]
            ),
            ),
        );
      },
    );
  }
}
