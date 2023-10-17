import 'dart:io';

import 'package:app/Model/user_model.dart';
import 'package:app/Services/others_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Profile/main_hinh_editProfile.dart';
import 'package:app/View/Pages/Profile/showAvatar.dart';
import 'package:app/View/Pages/Profile/tab_bookmark.dart';
import 'package:app/View/Pages/Profile/tab_video.dart';
import 'package:app/View/Pages/man_hinh_addFriend.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:app/View/Widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhNguoiKhac extends StatefulWidget {
  String uid;

  ManHinhNguoiKhac({Key? key, required this.uid}) : super(key: key);

  @override
  State<ManHinhNguoiKhac> createState() => _ManHinhNguoiKhacState();
}

class _ManHinhNguoiKhacState extends State<ManHinhNguoiKhac> {
  get stream => null;
  bool checkFollow = false;

  @override
  Widget build(BuildContext context) {
    bool isDialog = false;
    return StreamBuilder<DocumentSnapshot>(
        stream: UserService().getUser(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            UserModel userModel = UserModel.fromSnap(snapshot.data!);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Để quay lại màn hình trước đó
                  },
                ),
                title: Text(
                    userModel.fullName,
                    style: TextStyle(
                      color: Colors.black
                    ),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // AppBarCustom(context, userModel.fullName),
                    Avatar(userModel.avatarURL, context, isDialog, widget.uid),
                    SizedBox(height: 20),
                    text(
                        lable: userModel.idTopTop,
                        size: 18,
                        fontWeight: FontWeight.normal),
                    SizedBox(height: 20),
                    TrangThai(userModel.following!.length,
                        userModel.follower!.length, 5),
                    SizedBox(height: 30),
                    textButton(context, userModel.uid),
                    SizedBox(height: 10),
                    Expanded(child: TastBar()),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget AppBarCustom(BuildContext context, String fullname) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  fullname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Avatar(String url, BuildContext sContext, bool isDialog, String uid) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: sContext,
                        builder: (context) =>
                            showAvatarDialog(context, url, isDialog, uid));
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                ),
              ),
              const IconButton(
                onPressed: null,
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
                const text(
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
                const SizedBox(height: 5),
                const text(
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
  textButton(BuildContext context, String idOther) {
    Widget buttonFollow(BuildContext context) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.pinkAccent),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(100,
                40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
          ),
        ),
        onPressed: () {
          OthersService service = OthersService(); // Thay đổi cách khởi tạo đối tượng service
          service.FollowOther(idOther);
        },
        child: const Text(
          'Follow',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    Widget bottonFollowing(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                const Size(100,
                    40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Nhắn tin',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 5,),
          OutlinedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(30,
                      40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
                ),
              ),
              onPressed: () {
                OthersService service = OthersService();
                service.UnFollowOther(idOther);
              },
              child: Icon(
                  color: Colors.black,
                  size: 20,
                  Icons.undo
              )
          ),
        ],
      );
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: OthersService.getUserDataStream(),
      // Sử dụng hàm checkFollow ở đây
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buttonFollow(
              context); // Hiển thị một tiến trình đang tải nếu đang kiểm tra
        }
        if (snapshot.hasError) {
          print('Lỗi: ${snapshot.error}');
          return buttonFollow(context); // Xử lý lỗi nếu cần
        }
        final userData = UserModel.fromSnap(snapshot.data!);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userData.following != null && userData.following!.contains(idOther)
                ? bottonFollowing(context)
                : buttonFollow(context)
          ],
        );
      },
    );
  }
  TastBar() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: TabBarView(
                  children: [
                    TabVideo(widget.uid),
                    TabBookMark(),
                  ],
                ),
              ),
              const Positioned(
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

  showAvatarDialog(
      BuildContext context, String url, bool isDialog, String uId) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.only(
                            top: 350, bottom: 350, left: 10, right: 10),
                        child: Center(
                          child: Image.network(
                            url,
                            fit: BoxFit.scaleDown,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: AvatarCircle(
                    urlImage: url, widthImage: 100, heightImagel: 100)),
            Positioned(
              right: -10,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(25)),
                child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    ImagePick(ImageSource.gallery, context, isDialog, uId);
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  ImagePick(
      ImageSource src, BuildContext context, bool isDialog, String uId) async {
    final image = await ImagePicker().pickImage(source: src);
    if (image != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowAvatar(
            urlImage: File(image.path),
            onSave: () {
              Navigator.of(context).pop();
              isDialog = false;
            },
            uId: uId,
          )));
    }
  }
}
