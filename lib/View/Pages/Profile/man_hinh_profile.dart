import 'dart:io';

import 'package:app/Model/user_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Profile/main_hinh_editProfile.dart';
import 'package:app/View/Pages/Profile/man_hinh_addFriend.dart';
import 'package:app/View/Pages/Profile/showAvatar.dart';
import 'package:app/View/Pages/Profile/tab_bookmark.dart';
import 'package:app/View/Pages/Profile/tab_video.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Provider/page_provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../Widget/text.dart';
import '../Status/man_hinh_trang_thai.dart';

class ManHinhProfile extends StatefulWidget {
  const ManHinhProfile({Key? key}) : super(key: key);

  @override
  State<ManHinhProfile> createState() => _ManHinhProfileState();
}

class _ManHinhProfileState extends State<ManHinhProfile> {
  String uId = '';
  bool checkLogin = false;
  String idFolloer = '';

  @override
  void initState() {
    super.initState();
    _getId();
  }

  Future<void> _getId() async {
    final saveUid = FirebaseAuth.instance.currentUser;
    if (saveUid != null) {
      setState(() {
        uId = saveUid.uid;
        checkLogin = true;
      });
    } else {
      setState(() {
        checkLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    bool isDialog = false;
    return checkLogin
        ? StreamBuilder<DocumentSnapshot>(
            stream: UserService().getUser(uId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                UserModel userModel = UserModel.fromSnap(snapshot.data!);
                // idFolloer = userModel.follower as String;
                List<String>? follower = userModel.follower;
                List<String>? following = userModel.following;

                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: Column(
                      children: [
                        AppBarCustom(context,userModel.fullName),
                        Avatar(userModel.avatarURL, context, isDialog, uId),
                        SizedBox(height: 20),
                        text(
                            lable: userModel.idTopTop,
                            size: 18,
                            fontWeight: FontWeight.normal
                        ),
                        SizedBox(height: 20),
                        TrangThai(userModel.following!.length,
                            userModel.follower!.length, 5,following!,follower!),
                        SizedBox(height: 30),
                        textButton(context),
                        SizedBox(height: 10),
                        Expanded(child: TastBar(userModel.uid,pageProvider)),
                      ],
                    ),
                  ),
                );
              }
            })
        : Center(
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.pinkAccent)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ManHinhDangKy()));
                },
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(color: Colors.white),
                )),
          );
  }

  Widget AppBarCustom(BuildContext context,String fullname){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
              )
          ),
          Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  fullname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              )
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'item1') {
                    setState(() {
                      ProfileProvider provider = Provider.of(context,listen: false);
                      provider.setVideos([]);
                      UserService.signOutUser();
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Bottom_Navigation_Bar(),)
                      );
                    });
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'item1',
                    child: Text('Đăng xuất',style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
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

  TrangThai(int dangFollow, int follow, int like,List<String> following, List<String> follower) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManHinhTrangThai(username: uId,follow: follow,follower: dangFollow,uid: uId,initTab: 0,following: following,ngfollow: follower,id: id)));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManHinhTrangThai(uid: uId,follower: follower, following: following,initTab: 0)));
            },
            child: Container(
              child: Column(
                children: [
                  text(
                    lable: dangFollow.toString(),
                    size: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 5),
                  const text(
                      lable: "Đang follow", size: 15, fontWeight: FontWeight.normal),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManHinhTrangThai(username: uId,follow: follow,follower: dangFollow,uid: uId,initTab: 0)));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManHinhTrangThai(uid: uId,follower: follower, following: following,initTab: 1)));
            },
            child: Container(
              child: Column(
                children: [
                  text(
                      lable: follow.toString(),
                      size: 20,
                      fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 5),
                  const text(
                      lable: "Follower", size: 15, fontWeight: FontWeight.normal),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){
              
              print(uId);
            },
            child: Container(
              child: Column(
                children: [
                  text(
                    lable: like.toString(),
                    size: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 5),
                  const text(
                      lable: "Thích", size: 15, fontWeight: FontWeight.normal),
                ],
              ),
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
              const Size(100,
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
          child: const Text(
            'Sửa hồ sơ',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(20.0), // Đặt giá trị padding là 10
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              const Size(100,
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
          child: const Text(
            'Thêm bạn',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  TastBar(String uid, PageProvider pageProvider) {
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
                    TabVideo(uid,'TabVideo',pageProvider),
                    TabBookMark(uid,'TabBookMark',pageProvider),
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
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return Center(
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                    },
                  );
                },
                // child:
                // AvatarCircle(
                //     urlImage: url, widthImage: 100, heightImagel: 100)
              child: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(url),
                radius: 50,

              ),
            ),
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
