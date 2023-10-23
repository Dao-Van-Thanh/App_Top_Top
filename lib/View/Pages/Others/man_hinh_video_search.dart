import 'package:app/Model/video_model.dart';
import 'package:app/Provider/video_provider.dart';
import 'package:app/Services/call_video_service.dart';
import 'package:app/View/Widget/video_player_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';
typedef void RestoreOriginalListCallback();
class ManhinhVideoSearch extends StatefulWidget {
  final Stream<List<VideoModel>> videoStream;
  final RestoreOriginalListCallback restoreOriginalList;
  ManhinhVideoSearch({required this.videoStream, required this.restoreOriginalList});

  @override
  State<ManhinhVideoSearch> createState() => _ManhinhVideoSearchrState();
}

class _ManhinhVideoSearchrState extends State<ManhinhVideoSearch> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            widget.restoreOriginalList(); // Gọi callback để khôi phục danh sách ban đầu
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<VideoModel>>(
        stream: widget.videoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.black,
            );
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else {
            final videoList = snapshot.data;
            return Scaffold(
              extendBodyBehindAppBar: true,
              body: SafeArea(
                child: PageView.builder(
                  onPageChanged: (int page) {
                    print(videoList!.length - 1);
                    if (page == videoList!.length - 1) {
                      print('video cuối cùng rồi xem cái lol đi học đi');
                    }
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: videoList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final videoData = videoList?[index];
                    return ChangeNotifierProvider<VideoProvider>(
                      create: (context) => VideoProvider(),
                      child: Consumer<VideoProvider>(
                        builder: (context, videoProvider, child) {
                          videoProvider.setValue(
                              videoData!.likes.length,
                              videoData!.comments.length,
                              videoData!.caption,
                              videoData!.profilePhoto,
                              videoData!.username,
                              videoData!.id,
                              videoData!.uid,
                              videoData!.videoUrl
                          );
                          videoProvider.listVideo.addAll(videoList!);
                          if (!videoProvider.hasCheckedLike) {
                            videoProvider.hasCheckedLike = true;
                            CallVideoService()
                                .checkLike(videoData.likes.cast<String>())
                                .then((liked) {
                              if (liked) {
                                videoProvider.changeColor();
                              }
                            });
                            CallVideoService().checkFollowing(videoData.uid).then((value) => {
                              if (value || videoData.uid == _auth.currentUser!.uid){
                                videoProvider.setHasFollowing()
                              }
                            });
                          }
                          return Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              VideoPlayerItem(videoData!.videoUrl,videoData.id,videoProvider),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height / 10,
                                      child: VideoDetail(videoProvider),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height /
                                          1.75,
                                      child: HomeSideBar(
                                          videoProvider, CallVideoService(),'videoManHinhSearch',index,widget.videoStream),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
