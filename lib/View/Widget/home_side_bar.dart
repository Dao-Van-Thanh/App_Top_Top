
import 'package:app/Services/call_video_service.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_chinh_sua_video.dart';
import 'package:app/View/Pages/comments/dialog_comments.dart';
import 'package:app/View/Widget/appButtons.dart';
import 'package:app/View/Widget/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/video_model.dart';
import '../../Provider/page_provider.dart';
import '../../Provider/video_provider.dart';
import '../../Services/user_service.dart';
import '../Pages/Others/man_hinh_nguoi_khac.dart';

class HomeSideBar extends StatelessWidget {
  final VideoProvider videoProvider;
  final CallVideoService callVideoService;
  final String labelScreen;
  final int index;
  Stream<List<VideoModel>> _videoStream;
  HomeSideBar(this.videoProvider, this.callVideoService, this.labelScreen, this.index, this._videoStream);
  Stream<List<VideoModel>> get videoStream => _videoStream;
  @override
  Widget build(BuildContext context) {
    final CallVideoService callVideoService;
    final _auth = FirebaseAuth.instance;
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 13, color: Colors.white);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5), // Điều chỉnh khoảng cách dưới
              child: _profileImageButton(context),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5), // Điều chỉnh khoảng cách dưới
              child: _sideBarItem('heart', videoProvider.countLike, style, 0, videoProvider.iconColors[0], context),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5), // Điều chỉnh khoảng cách dưới
              child: _sideBarItem('comment', videoProvider.countComment, style, 1, Colors.white, context),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5), // Điều chỉnh khoảng cách dưới
              child: _sideBarItem('save', videoProvider.countSave, style, 2, videoProvider.iconColors[1], context),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5), // Điều chỉnh khoảng cách dưới
              child: _sideBarItem('share', 1, style, 2, videoProvider.iconColors[2], context),
            ),
            videoProvider.authorId == _auth.currentUser!.uid
                ? Container(
              margin: EdgeInsets.only(bottom: 10), // Điều chỉnh khoảng cách dưới
              child: _sideBarItem('more', 1, style, 2, videoProvider.iconColors[2], context),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
  var labelIcon ={
    Icons.delete_forever:"Xóa",
    Icons.edit:"Chỉnh sửa",
    Icons.download:"Lưu video",
    Icons.push_pin:"Ghim",
    Icons.speed:"Tốc độ",
    Icons.speed_outlined:"Tốc độ1",
    Icons.speed_sharp:"Tốc độ2",
    Icons.shutter_speed_outlined:"Tốc độ3",
  };
  _showDialog(context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Xóa video này?',style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child:
                  Text('Hủy',style: TextStyle(color: Colors.grey.withOpacity(0.8)),),
            ),
            TextButton(
              onPressed: () {
                CallVideoService().deleteVideo(videoProvider.videoId);
                Navigator.of(context).pop();
                pageProvider.setPageProfile();
              },
              child:
              Text('Xóa', style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }
  Widget _sideBarItem(
      String iconName, int label, TextStyle style, int index1, Color color, BuildContext context ) {
    IconData iconData;
    // Dựa vào tên iconName, bạn có thể map nó thành IconData tương ứng
    if (iconName == 'heart') {
      iconData = Icons.favorite;
    } else if (iconName == 'comment') {
      iconData = Icons.comment;
    } else if (iconName == 'share') {
      iconData = Icons.share;
    }
    else if (iconName == 'save') {
      iconData = Icons.bookmark;
    }else {
      iconData = Icons.more_horiz;
    }
    double heightDialog = MediaQuery.of(context).size.height * 0.6;
    return Column(
      children: [
        InkWell(
          onTap: () {
            switch (iconName) {
              case 'heart':
                if(labelScreen =='videoManHinhSearch'){
                  callVideoService.likeVideo(videoProvider.videoId);
                  videoProvider.incrementLike();
                  final _auth = FirebaseAuth.instance;
                  final likes = videoProvider.listVideo[index].likes;
                  if (likes.contains(_auth.currentUser!.uid)) {
                    likes.remove(_auth.currentUser!.uid);
                  } else {
                    likes.add(_auth.currentUser!.uid);
                  }
                  videoProvider.listVideo[index].likes = likes;
                  _videoStream = Stream.value(videoProvider as List<VideoModel>);
                }else{
                  videoProvider.incrementLike();
                  callVideoService.likeVideo(videoProvider.videoId);
                }
                break;
              case 'save':
                if(labelScreen =='videoManHinhSearch'){
                  videoProvider.incrementSaveVideo();
                  callVideoService.saveVideo(videoProvider.videoId);
                  final _auth = FirebaseAuth.instance;
                  final userSaveVides = videoProvider.listVideo[index].userSaveVideos;
                  if (userSaveVides!.contains(_auth.currentUser!.uid)) {
                    userSaveVides.remove(_auth.currentUser!.uid);
                  } else {
                    userSaveVides.add(_auth.currentUser!.uid);
                  }
                  videoProvider.listVideo[index].userSaveVideos = userSaveVides;
                  _videoStream = Stream.value(videoProvider as List<VideoModel>);
                }else{
                  videoProvider.incrementSaveVideo();
                  callVideoService.saveVideo(videoProvider.videoId);
                }
                break;
              case 'comment':
                showBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Container(
                    width: double.infinity,
                    height: heightDialog,
                    color: Colors.white,
                    child: CommentsDialog(
                      videoId: videoProvider.videoId,
                      videoProvider: videoProvider,
                      commentsSize: videoProvider.countComment,
                    ),
                  ),
                );
                break;
              case 'more':{
                showDialog(context: context, builder: (BuildContext context) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 230,
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Column(
                        children: [
                          Text('Gửi đến', style: TextStyle(color: Colors.black)),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              children: List.generate(10, (index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: AppButtons(size: 60, color: Colors.grey, backgroundColor: Colors.grey, boderColor: Colors.grey),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              children: List.generate(labelIcon.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Xử lý sự kiện khi mục được nhấn
                                    switch (labelIcon.values.elementAt(index)) {
                                      case 'Xóa':
                                        Navigator.of(context).pop();
                                        _showDialog(context);
                                        break;
                                      case 'Chỉnh sửa':
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ManHinhChinhSuaVideo(videoProvider: videoProvider),
                                          ),
                                        );
                                        break;
                                      default:
                                      // Thực hiện hành động mặc định khi nhấn vào các mục khác
                                        break;
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: AppButtons(size: 60, color: Colors.black, backgroundColor: Colors.grey.withOpacity(0.3), boderColor: Colors.grey.withOpacity(0.3), text: labelIcon.values.elementAt(index), icon: labelIcon.keys.elementAt(index)),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
                break;
              }
              case 'share':{
                ShareVideo.shareVideo(videoProvider.videoId, videoProvider.videoUrl);
                break;
              }
              default:
            }
          },
          child: Icon(
            iconData,
            size: 35,
            color: color,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        iconData==Icons.more_horiz?SizedBox():Text(
          label.toString(),
          style: style,
        ),
      ],
    );
  }

  Widget _profileImageButton(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final pageProvider = Provider.of<PageProvider>(context, listen: false);;
    return GestureDetector(
      onTap: () {
        if(videoProvider.authorId == _auth.currentUser!.uid){
          pageProvider.setPageProfile();
        }else{
          if(labelScreen == 'man hinh nguoi khac'){
            Navigator.of(context).pop();
          }else{
            videoProvider.changeControlVideo();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManHinhNguoiKhac(videoProvider.authorId,videoProvider)));
          }
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(videoProvider.profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
            transform: Matrix4.translationValues(5, 0, 0),
          ),
          videoProvider.hasFollowing == false?
          Positioned(
            bottom: -10,
            child: GestureDetector(
              onTap: () {
                UserService().followUser(videoProvider.authorId);
                videoProvider.setHasFollowing();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),
                transform: Matrix4.translationValues(5, 0, 0),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ):SizedBox()
        ],
      ),
    );
  }

}

