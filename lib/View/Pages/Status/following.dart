import 'package:app/Services/user_service.dart';
import 'package:app/View/Widget/sreach_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/user_model.dart';
import '../../../Provider/follow_provider.dart';
import '../../../Provider/video_provider.dart';
import '../../Widget/user_card.dart';
import '../Others/man_hinh_nguoi_khac.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key, this.uId, required this.following});
  final List<String> following;
  final String? uId;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool check = true;
  UserService service = UserService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            searchWidget(),
            const SizedBox(height: 20),
            Column(
              children: widget.following.map((id) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: UserService().getUser(id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(color: Colors.white);
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      UserModel followingUser =
                      UserModel.fromSnap(snapshot.data!);
                      String followingUserName = followingUser.fullName;
                      // Hiển thị thông tin người dùng theo ý của bạn
                      bool check = followingUser.follower!.contains(widget.uId);
                      return ItemView(
                        followingUserName,
                        followingUser.avatarURL,
                        followingUser.idTopTop,
                        widget.uId!,
                        followingUser.uid,
                        check,
                      );
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Tài khoản được đề xuất",
                      ),
                      Icon(Icons.warning_amber_sharp,size: 15),
                    ],
                  ),
                  FutureBuilder(
                    future: UserService().getListFriend(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        var userData = snapshot.data!;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  final followProvider = ChangeNotifierProvider.value(
                                    value: FollowProvider(),
                                    child: UserCard(userData: userData[index],heightImage: 40,widthImage: 40,checkScreen: false),
                                  );
                                  return followProvider;
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ItemView(String userName, String Url, String idTikTok,String uid, String idOther,bool check) {
    VideoProvider videoProvider = VideoProvider();
    final followProvider = Provider.of<FollowProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManHinhNguoiKhac(idOther,videoProvider)));
              },
              child: SizedBox(
                child: CircleAvatar(
                  foregroundColor: Colors.black,
                  foregroundImage: NetworkImage(Url),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  userName.length > 20
                      ? '${userName.substring(0, 20)}...'
                      : userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  idTikTok.substring(1).replaceAll('', ''),
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if(check == true){
              UserService().unfollowUser(idOther);
            }else{
              UserService().followUser(idOther);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: check ? Colors.grey : Colors.redAccent, // Màu nền đỏ
            onPrimary: Colors.white, // Màu chữ trắng
            minimumSize: const Size(150, 40), // Đặt chiều dài và chiều rộng mong muốn
          ),
          child: check ? const Text("Đang Follow") : const Text("Follow"),
        ),
      ],
    );
  }
}
