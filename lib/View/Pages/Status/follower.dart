import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Model/user_model.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/user_service.dart';
import '../Others/man_hinh_nguoi_khac.dart';

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({super.key, this.uId, required this.follower});

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
          // searchWidget(),
          const SizedBox(height: 20),
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
                        return itemView(
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

  Widget itemView(String userName, String url, String idTikTok,String uid, String idOther,bool check) {
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
                  foregroundImage: NetworkImage(url),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                  idTikTok,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
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
            foregroundColor: Colors.white, backgroundColor: check ? Colors.grey : Colors.redAccent, // Màu chữ trắng
            minimumSize: const Size(150, 40), // Đặt chiều dài và chiều rộng mong muốn
          ),
          child: check ? const Text("Đang Follow") : const Text("Follow lại"),
        ),
      ],
    );
  }

}
