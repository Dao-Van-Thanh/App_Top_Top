import 'dart:io';

import 'package:app/Model/user_model.dart';
import 'package:app/Services/others_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Profile/showAvatar.dart';
import 'package:app/View/Pages/Profile/tab_bookmark.dart';
import 'package:app/View/Pages/Profile/tab_video.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:app/View/Widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Provider/page_provider.dart';
import '../../../Provider/video_provider.dart';

class ManHinhNguoiKhac extends StatefulWidget {
  final String uid;
  final VideoProvider videoProvider;

  const ManHinhNguoiKhac(this.uid, this.videoProvider, {Key? key})
      : super(key: key);

  @override
  State<ManHinhNguoiKhac> createState() => _ManHinhNguoiKhacState();
}

class _ManHinhNguoiKhacState extends State<ManHinhNguoiKhac> {
  get stream => null;
  bool checkFollow = false;

  @override
  Widget build(BuildContext context) {
    bool isDialog = false;
    final pageProvider = Provider.of<PageProvider>(context);
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
                    widget.videoProvider.changeControlVideo();
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                    userModel.fullName,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // AppBarCustom(context, userModel.fullName),
                    avatar(userModel.avatarURL, context, isDialog, widget.uid),
                    const SizedBox(height: 20),
                    TextWidget(
                        lable: userModel.idTopTop,
                        size: 18,
                        fontWeight: FontWeight.normal),
                    const SizedBox(height: 20),
                    trangThai(userModel.following!.length,
                        userModel.follower!.length, 5),
                    const SizedBox(height: 30),
                    textButton(context, userModel.uid),
                    const SizedBox(height: 10),
                    Expanded(child: tastBar(pageProvider)),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget appBarCustom(BuildContext context, String fullname) {
    return SizedBox(
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

  avatar(String url, BuildContext sContext, bool isDialog, String uid) {
    return Column(
      children: [
        const SizedBox(height: 10),
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
    );
  }

  trangThai(int dangFollow, int follow, int like) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: [
              TextWidget(
                  lable: dangFollow.toString(),
                  size: 20,
                  fontWeight: FontWeight.w900),
              const SizedBox(height: 5),
              const TextWidget(
                  lable: "Đang follow",
                  size: 15,
                  fontWeight: FontWeight.normal),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextWidget(
                  lable: follow.toString(),
                  size: 20,
                  fontWeight: FontWeight.w900),
              const SizedBox(height: 5),
              const TextWidget(
                  lable: "Follower", size: 15, fontWeight: FontWeight.normal),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextWidget(
                  lable: like.toString(),
                  size: 20,
                  fontWeight: FontWeight.w900),
              const SizedBox(height: 5),
              const TextWidget(lable: "Thích", size: 15, fontWeight: FontWeight.normal),
            ],
          ),
        ),
      ],
    );
  }
  textButton(BuildContext context, String idOther) {
    Widget buttonFollow(BuildContext context) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.pinkAccent),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(100,
                40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
          ),
        ),
        onPressed: () async {
          OthersService service = OthersService(); // Thay đổi cách khởi tạo đối tượng service
          await service.followOther(idOther);
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
          const SizedBox(width: 5,),
          OutlinedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(30,
                      40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
                ),
              ),
              onPressed: () {
                OthersService service = OthersService();
                service.unFollowOther(idOther);
                widget.videoProvider.setHasFollowing();
              },
              child: const Icon(
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
          debugPrint('Lỗi: ${snapshot.error}');
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
  tastBar(PageProvider pageProvider) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: TabBarView(
                  children: [
                    TabVideo(widget.uid,'TabVideo',pageProvider),
                    TabBookMark(widget.uid,'TabBookMark',pageProvider),
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
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    imagePick(ImageSource.gallery, context, isDialog, uId);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  imagePick(
      ImageSource src, BuildContext context, bool isDialog, String uId) async {
    final image = await ImagePicker().pickImage(source: src);
    if (image != null) {
      if(!context.mounted) return;
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
