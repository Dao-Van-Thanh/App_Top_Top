import 'dart:ui';

import 'package:app/Model/user_model.dart';
import 'package:app/Services/tab_video_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Admin/user_screen_video.dart';
import 'package:app/View/Pages/Profile/main_hinh_editProfile.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.uid});

  final String uid;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  int _calculateDaysSinceRegistration(String registrationTime) {
    try {
      DateTime registrationDateTime = DateTime.parse(registrationTime);
      DateTime now = DateTime.now();
      Duration difference = now.difference(registrationDateTime);
      int days = difference.inDays;
      return days;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserService().getUser(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        UserModel userModel = UserModel.fromSnap(snapshot.data!);

        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(userModel.fullName,
                    style: const TextStyle(color: Colors.black))),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userModel.avatarURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        // Độ mờ
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              userModel.avatarURL,
                            ),
                            maxRadius: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                  "Đã hoạt động được: ${_calculateDaysSinceRegistration(userModel.realTime)} Ngày"),
              const SizedBox(height: 50),
              textButton("Thông tin cá nhân", context, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(uid: userModel.uid)));
              }),
              const SizedBox(height: 50),
              textButton("Thay đổi mật khẩu", context, () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Center(child: Text('Thay đổi mật khẩu')),
                      actions: [
                        Column(
                          children: [
                            const TextField(
                              decoration:
                                  InputDecoration(hintText: 'New Password'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Đã thay đổi mật khẩu thành công.'),
                                      ));
                                      Future.delayed(const Duration(seconds: 1), () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      });
                                    },
                                    child: const Text('Lưu')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Hủy')),
                              ],
                            )
                          ],
                        )
                      ],
                    );
                  },
                );
              }),
              const SizedBox(height: 50),
              FutureBuilder(
                future: TabVideoService.getVideosByUid(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center();
                  }
                  // VideoModel videoModel = VideoModel.fromSnap(snapshot.data!)

                  return textButton("${snapshot.data!.length} Videos", context,(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>UserScreenVideo(widget.uid)));

                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget textButton(String title, BuildContext context, VoidCallback onPress) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
        ),
        onPressed: onPress,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Colors.black, fontSize: 18)),
              const Icon(Icons.navigate_next, color: Colors.black)
            ],
          ),
        ));
  }
}
