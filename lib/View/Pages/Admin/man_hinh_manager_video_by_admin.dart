import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/video_model.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/call_video_service.dart';
import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';
import '../../Widget/video_player_item.dart';

class ManHinhManagerVideoByAdmin extends StatefulWidget {
  final String uid;
  final int index;
  final bool status;
  const ManHinhManagerVideoByAdmin(
      {super.key,
      required this.uid,
      required this.index,
      required this.status});
  @override
  State<ManHinhManagerVideoByAdmin> createState() =>
      _ManHinhManagerVideoByAdminState();
}

class _ManHinhManagerVideoByAdminState
    extends State<ManHinhManagerVideoByAdmin> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final Stream<List<VideoModel>> videoStream;
    videoStream = CallVideoService().getVideosStreamByAuthor(widget.uid);
    PageController controller = PageController(initialPage: widget.index);
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<VideoModel>>(
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
              extendBodyBehindAppBar: true,
              body: SafeArea(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (int page) {
                    if (page == videoList!.length - 1) {}
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
                              videoData.blockComments);
                          if (!videoProvider.hasCheckedLike) {
                            videoProvider.hasCheckedLike = true;
                            CallVideoService()
                                .checkLike(videoData.likes.cast<String>())
                                .then((liked) {
                              if (liked) {
                                videoProvider.changeColor();
                              }
                            });
                            CallVideoService()
                                .checkFollowing(videoData.uid)
                                .then((value) => {
                                      if (value ||
                                          videoData.uid ==
                                              auth.currentUser!.uid)
                                        {videoProvider.setHasFollowing()}
                                    });
                            CallVideoService()
                                .checkUserSaveVideo(
                                    videoData.userSaveVideos!.cast<String>())
                                .then((save) {
                              if (save) {
                                videoProvider.changeColorSave();
                              }
                            });
                          }
                          return GestureDetector(
                            onTap: () => FocusScope.of(context)
                                .requestFocus(FocusNode()),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                widget.status == false
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 3,
                                            left: 13,
                                            right: 13,
                                            bottom: 3),
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    videoData.videoUrl),
                                                fit: BoxFit.cover)),
                                      )
                                    : VideoPlayerItem(videoData.videoUrl,
                                        videoData.id, videoProvider),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                        child: VideoDetail(videoProvider),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.75,
                                        child: HomeSideBar(
                                            videoProvider,
                                            CallVideoService(),
                                            'man_hinh_quan_ly_video_by_admin',
                                            index,
                                            videoStream),
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
      ),
    );
  }
}
