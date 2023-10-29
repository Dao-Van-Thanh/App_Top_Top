import 'package:app/Provider/comments_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Model/user_model.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/user_service.dart';
import '../../Widget/sreach_user.dart';
import '../Others/man_hinh_nguoi_khac.dart';

class FollowerScreen extends StatefulWidget {
  FollowerScreen({this.uId, required this.follower});

  final List<String> follower;
  final String? uId;

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
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
                itemCount: widget.follower.length,
                itemBuilder: (context, index) {
                  String id = widget.follower[index];
                  return StreamBuilder<DocumentSnapshot>(
                    stream: UserService().getUser(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Colors.white);
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        UserModel followerUser =
                        UserModel.fromSnap(snapshot.data!);
                        String followingUserName =followerUser.fullName;
                        // Hiển thị thông tin người dùng theo ý của bạn
                        bool check = followerUser.follower!.contains(widget.uId);
                        return ItemView(
                            followingUserName,
                            followerUser.avatarURL,
                            followerUser.idTopTop,
                            widget.uId!,
                            followerUser.uid,
                            check
                        );
                      }
                    },
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget ItemView(String userName, String Url, String idTikTok,String uid, String idOther,bool check) {
    VideoProvider videoProvider = VideoProvider();
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
          child: check ? Text("Đang Follow") : Text("Follow lại"),
        ),
      ],
    );
  }

}
