import 'dart:io';

import 'package:app/View/Screen/Profile/main_hinh_editProfile.dart';
import 'package:app/View/Screen/Profile/showAvatar.dart';
import 'package:app/View/Screen/Profile/tab_bookmark.dart';
import 'package:app/View/Screen/Profile/tab_video.dart';
import 'package:app/View/Screen/man_hinh_addFriend.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:app/View/Widget/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManHinhProfile extends StatelessWidget {
  const ManHinhProfile({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Avatar(
                'https://cdn.pixabay.com/photo/2016/11/14/04/36/boy-1822614_640.jpg',
                context),
            SizedBox(height: 20),
            text(lable: 'Username', size: 18, fontWeight: FontWeight.normal),
            SizedBox(height: 20),
            TrangThai(10, 5, 5),
            SizedBox(height: 30),
            textButton(context),
            SizedBox(height: 10),
            Expanded(child: TastBar()),
          ],
        ),
      ),
    );
  }

  Avatar(String url, BuildContext sContext) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: sContext,
                        builder: (context) => showAvatarDialog(context, url));
                  },
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.upload, color: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }

  TrangThai(int dangFollow, int follow, int like) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                text(
                    lable: dangFollow.toString(),
                    size: 20,
                    fontWeight: FontWeight.w900),
                SizedBox(height: 5),
                text(
                    lable: "Đang follow",
                    size: 15,
                    fontWeight: FontWeight.normal),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                text(
                    lable: follow.toString(),
                    size: 20,
                    fontWeight: FontWeight.w900),
                SizedBox(height: 5),
                text(
                    lable: "Follower", size: 15, fontWeight: FontWeight.normal),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                text(
                    lable: like.toString(),
                    size: 20,
                    fontWeight: FontWeight.w900),
                SizedBox(height: 5),
                text(lable: "Thích", size: 15, fontWeight: FontWeight.normal),
              ],
            ),
          ),
        ),
      ],
    );
  }

  textButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(20.0), // Đặt giá trị padding là 10
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              Size(100,
                  40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    EditProfile(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0,
                      1.0); // Điểm bắt đầu (nếu bạn muốn chuyển từ bên phải)
                  const end = Offset
                      .zero; // Điểm kết thúc (nếu bạn muốn hiển thị ở giữa)
                  const curve =
                      Curves.easeInOut; // Loại chuyển cảnh (có thể tùy chỉnh)
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            'Sửa hồ sơ',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(width: 20),
        OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(20.0), // Đặt giá trị padding là 10
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              Size(100,
                  40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AddFriend(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0,
                      1.0); // Điểm bắt đầu (nếu bạn muốn chuyển từ bên phải)
                  const end = Offset
                      .zero; // Điểm kết thúc (nếu bạn muốn hiển thị ở giữa)
                  const curve =
                      Curves.easeInOut; // Loại chuyển cảnh (có thể tùy chỉnh)
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            'Thêm bạn',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  TastBar() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: TabBarView(
                  children: [
                    TabVideo(),
                    TabBookMark(),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: TabBar(
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                        child: Icon(
                      Icons.video_collection,
                      color: Colors.black,
                    )),
                    Tab(
                        child: Icon(
                      Icons.bookmark,
                      color: Colors.black,
                    )),
                  ],
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                ),
              ),
            ],
          ),
        ));
  }

  showAvatarDialog(BuildContext context, String url) {
    return Column(
      children: [
        SizedBox(height: 10),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            AvatarCircle(urlImage: url, widthImage: 100, heightImagel: 100),
            Positioned(
              right: -15,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  onPressed: () {ImagePick(ImageSource.gallery,context);},
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
  ImagePick(ImageSource src,BuildContext context) async{
    final image = await ImagePicker().pickImage(source: src);
    if(image != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowAvatar(urlImage: File(image.path))));
    }
  }

}
