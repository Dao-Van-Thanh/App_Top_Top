
import 'package:app/Services/call_video_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/Provider/emoji_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/TrangChu/dialog_comments.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/page_provider.dart';
import '../../Provider/video_provider.dart';
import '../Pages/Others/man_hinh_nguoi_khac.dart';

class HomeSideBar extends StatelessWidget {
  final VideoProvider videoProvider;
  final CallVideoService callVideoService;
  const HomeSideBar(this.videoProvider, this.callVideoService, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CallVideoService callVideoService;
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
            _profileImageButton(context),
            _sideBarItem('heart', videoProvider.countLike, style, 0,
                videoProvider.iconColors[0],context),
            _sideBarItem('comment', videoProvider.countComment, style, 1,
                videoProvider.iconColors[1],context),
            _sideBarItem('share', 1, style, 2, videoProvider.iconColors[2],context),
          ],
        ),
      ),
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
    } else {
      iconData = Icons.star;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            switch (iconName) {
              case 'heart':
                videoProvider.incrementLike();
                callVideoService.likeVideo(videoProvider.videoId);
                break;
              case 'comment':
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Align(
                      alignment: Alignment.bottomCenter, // Hiển thị ở cuối màn hình
                      child: Container(
                        width: double.infinity, // Đặt chiều rộng đầy đủ
                        height: 700.0, // Đặt chiều cao cố định
                        color: Colors.white, // Màu nền của dialog
                        child: CommentsDialog(videoId:videoProvider.videoId), // Thay thế YourDialogContent bằng nội dung của bạn
                      ),
                    );
                  },
                );
                break;
              default:
            }
          },
          child: Icon(
            iconData,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label.toString(),
          style: style,
        ),
      ],
    );
  }

  Widget _profileImageButton(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final pageProvider = Provider.of<PageProvider>(context);
    return GestureDetector(
      onTap: () {
        if(videoProvider.authorId == _auth.currentUser!.uid){
          pageProvider.setPageProfile();
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => ManHinhNguoiKhac(uid: videoProvider.authorId)));
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 40,
            width: 40,
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
          Positioned(
            bottom: -10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              transform: Matrix4.translationValues(5, 0, 0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

