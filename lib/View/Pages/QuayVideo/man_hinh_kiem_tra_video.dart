import 'dart:io';
import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_cut_video.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_dang_video.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../Model/music_model.dart';
import '../../../Provider/music_provider.dart';
import '../../Widget/app_item_music.dart';

class ManHinhKiemTraVideo extends StatefulWidget {
  final XFile file;

  ManHinhKiemTraVideo(this.file);

  @override
  State<ManHinhKiemTraVideo> createState() => _ManHinhKiemTraVideoState();
}

class _ManHinhKiemTraVideoState extends State<ManHinhKiemTraVideo> {
  late XFile file;

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

  @override
  void initState() {
    super.initState();
    file = widget.file;
    WidgetsFlutterBinding.ensureInitialized();
    videoController = VideoPlayerController.file(File(file.path));
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
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
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
                    flex: 11,
                  ),
                  Expanded(
                    // flex: 1,
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
                                  String songUrl = '';
                                  try {
                                    songUrl = musicProvider.linkUrl;
                                  } catch (e) {
                                    print(e);
                                  }
                                  videoController?.dispose();
                                  musicProvider.stopAudio();
                                  print('==================${file.path}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ManHinhDangVideo(file, songUrl),
                                      ));
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
                title: GestureDetector(
                  onTap: () {
                    showBottomDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.6)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 20,
                        ),
                        Expanded(
                            child: Text(
                          provider.title,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))
                      ],
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () async {
                    bool cancel = (await _showCancelDialog()) as bool;
                    if (cancel) {
                      // provider.dispose();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.sizeOf(context).height * 0.05,
                right: MediaQuery.sizeOf(context).width * 0.02,
                child: Container(
                    width: 30,
                    height: 100,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            videoController?.pause();
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManHinhCatVideo(File(file.path)),
                                ));
                            if (result != null) {
                              print('đã vào đây $result');
                              videoController =
                                  VideoPlayerController.file(File(result));
                              videoController?.play();
                              videoController?.initialize().then((value) => {
                                    if (mounted)
                                      {
                                        setState(() {
                                          file = XFile(result);
                                        })
                                        // Kích hoạt lại build để hiển thị video
                                      }
                                  });
                            }
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/cut-video-player.png'),
                              SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Sửa',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    )))
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

  void showBottomDialog(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    final player = AudioPlayer();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Đặt isScrollControlled thành true
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: ListView.builder(
                itemCount: musicProvider.musics.length,
                itemBuilder: (context, index) {
                  return Consumer<MusicProvider>(
                      builder: (context, musicProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () async {
                          musicProvider.toggleMusicFocus(index);
                          if (musicProvider.musics[index].isFocus == true) {
                            musicProvider.initAudioPlayer(index);
                            provider
                                .setTitle(musicProvider.musics[index].title);
                          } else {
                            musicProvider.stopAudio();
                            provider.setTitle('Thêm âm thanh');
                          }
                        },
                        child: AppItemMusic(
                          thumb: musicProvider.musics[index].thumb,
                          title: musicProvider.musics[index].title,
                          isForcus: musicProvider.musics[index].isFocus,
                        ),
                      ),
                    );
                  });
                }));
      },
    );
  }
}
