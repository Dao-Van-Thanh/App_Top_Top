import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/video_model.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/call_video_service.dart';
import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';
import '../../Widget/video_player_item.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _Following();
}

class _Following extends State<Following> {
  @override
  Widget build(BuildContext context) {
    final Stream<List<VideoModel>> videoStream;
    final auth = FirebaseAuth.instance;
    videoStream = CallVideoService().getVideosFollowingStream();
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
                onPageChanged: (int page) {
                  print(page);
                  print(videoList!.length - 1);
                  if (page == videoList.length - 1) {
                    print('video cuối cùng rồi xem cái lol đi học đi');
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

                        return GestureDetector(
                          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              VideoPlayerItem( videoData.videoUrl,videoData.id,videoProvider),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height / 10,
                                      child: VideoDetail(videoProvider),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          1.75,
                                      child: HomeSideBar(
                                          videoProvider, CallVideoService(),'manhinhfollowing',index,videoStream),
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
