import 'dart:async';

import 'package:app/Model/video_model.dart';
import 'package:app/Provider/video_provider.dart';
import 'package:app/Services/call_video_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Video extends StatefulWidget {
  const Video({super.key});


  @override
  State<Video> createState() => _ForYouState();
}

class _ForYouState extends State<Video> {
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
    final auth = FirebaseAuth.instance;
    videoStream = CallVideoService().getVideosStream();
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
          List<String> videoUrl=[];
          for(int i =0;i<videoList!.length;i++){
            videoUrl.add(videoList[i].videoUrl);
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            body: SafeArea(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (int page) {
                  if (page == videoList.length - 1) {
                    print('video cuối cùng rồi xem cái lol đi học đi');
                  }
                },
                scrollDirection: Axis.vertical,
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  final videoData = videoList[index];
                  return ChangeNotifierProvider<VideoProvider>(
                    create: (context) => VideoProvider(),
                    child: Consumer<VideoProvider>(
                      builder: (context, videoProvider, child) {
                        videoProvider.setValue(
                            videoData.blockComments,
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
                            if (value || videoData.uid == auth.currentUser!.uid){
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
                        return Container();
                        // return AdPage();
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
