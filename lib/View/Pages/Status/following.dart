import 'dart:ui';

import 'package:app/Provider/emoji_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Widget/sreach_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Model/user_model.dart';

class FollowingScreen extends StatefulWidget {
  FollowingScreen({this.uId, required this.following});
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
      body: Column(
        children: [
          searchWidget(),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
            itemCount: widget.following.length,
            itemBuilder: (context, index) {
              String id = widget.following[index];
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
                    print(followingUserName);
                    // Hiển thị thông tin người dùng theo ý của bạn
                    bool check = followingUser.follower!.contains(widget.uId);
                    return ItemView(
                      followingUserName,
                      followingUser.avatarURL,
                      followingUser.idTopTop,
                      widget.uId!,
                      followingUser.uid,
                        check
                    );
                  }
                },
              );
            },
          ))
        ],
      ),
    );
  }

  Widget ItemView(String userName, String Url, String idTikTok,String uid, String idOther,bool check) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              child: CircleAvatar(
                foregroundColor: Colors.black,
                foregroundImage: NetworkImage(Url),
              ),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  idTikTok,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if(check == true){
              service.unfollowUser(idOther);
            }else{
              service.followUser(idOther);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: check ? Colors.grey : Colors.redAccent, // Màu nền đỏ
            onPrimary: Colors.white, // Màu chữ trắng
            minimumSize: Size(150, 40), // Đặt chiều dài và chiều rộng mong muốn
          ),
          child: check ? Text("Đang Follow") : Text("Follow"),
        ),
      ],
    );
  }
}
