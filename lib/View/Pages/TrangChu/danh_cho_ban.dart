import 'dart:async';

import 'package:app/Model/video_model.dart';
import 'package:app/Provider/video_provider.dart';
import 'package:app/Services/call_video_service.dart';
import 'package:app/View/Widget/video_player_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';

class ForYou extends StatefulWidget {

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<List<VideoModel>> videoStream;
    final _auth = FirebaseAuth.instance;
    late String videoUrl;
    String? tempVideoUrl;
    bool isVideoLoaded = false;
    void prepareNextPageVideo(int index,List<VideoModel> videoList) {
      if (index + 1 < videoList!.length) {
        final nextPageVideoData = videoList![index + 1].videoUrl;
        videoUrl = nextPageVideoData;
        isVideoLoaded = true;
      }
    }
    videoStream = CallVideoService().getVideosStream1000();
    return StreamBuilder<List<VideoModel>>(
      stream: videoStream,
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
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            body: SafeArea(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (int page) {
                  if (page == videoList!.length - 1) {
                      print('video cuối cùng rồi xem cái lol đi học đi');
                  }
                  // prepareNextPageVideo(page,videoList);
                  // if (videoUrl != null) {
                  //   tempVideoUrl = videoUrl;
                  // }
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
                            videoData!.blockComments,
                            videoData.likes.length,
                            videoData.comments.length,
                            videoData.userSaveVideos!.length,
                            videoData.caption,
                            videoData.profilePhoto,
                            videoData.username,
                            videoData.id,
                            videoData.uid,
                          videoData.videoUrl,
                          videoData.blockComments
                        );
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
                          CallVideoService().checkUserSaveVideo(videoData.userSaveVideos!.cast<String>())
                          .then((save){
                            if (save) {
                              videoProvider.changeColorSave();
                            }
                          });
                        }
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              VideoPlayerItem(
                                videoUrl=videoData.videoUrl,
                                videoData.id,
                                videoProvider,
                                videoData.songUrl,
                              ),
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
                                          videoProvider, CallVideoService(),'manhinhchoban',index,videoStream),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
