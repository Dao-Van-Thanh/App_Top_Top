import 'package:app/Provider/emoji_provider.dart';
import 'package:app/Services/comment_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:app/View/Widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsDialog extends StatefulWidget {
  const CommentsDialog({Key? key}) : super(key: key);
  // final String videoId;

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  String uId = '';
  bool checkLogin = false;
  final textController = TextEditingController();
  bool isEmoji = false;
  String videoId = "";
  @override
  void initState() {
    // TODO: implement initState
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
    return StreamBuilder<DocumentSnapshot>(
      stream: CommentService().getCmtVideo('DatKUmNPqyKbCyq7sZZB'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final data = snapshot.data?.data() as Map<String, dynamic>;
          final comments = data?['comments'] as List<dynamic>;
          List<String> uIds = [];
          comments.forEach( (comment) {
            if (comment is Map<String, dynamic> && comment.containsKey('uid')) {
              String uid = comment['uid'];
              uIds.add(uid);
            }
          });

          if (comments.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Không có bình luận nào.",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.redAccent,
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return showComment( cmtData: comments[index]);
                      }),
                  Positioned(
                      bottom: 0,
                      child: Column(
                        children: [
                          footerDialog(
                              'https://cdn.pixabay.com/photo/2023/08/11/06/12/boy-8182923_640.jpg',
                              'DatKUmNPqyKbCyq7sZZB'),
                          // SizedBox(
                          //   height: 200,
                          //   child: EmojiPicker(
                          //     textEditingController: textController,
                          //     config: Config(
                          //       columns: 3,
                          //     ),
                          //   ),
                          // )
                        ],
                      )),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  footerDialog(String urlImage, String videoId) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              AvatarCircle(
                  urlImage: urlImage, widthImage: 50, heightImagel: 50),
              SizedBox(width: 5),
              Expanded(
                child: Card(
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            maxLines: 2,
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Thêm bình luận....',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isEmoji = !isEmoji;
                          });
                        },
                        icon: Icon(Icons.emoji_emotions),
                      ),
                      IconButton(
                          onPressed: () {
                            CommentService().sendCmt(
                                videoId, textController.text.trim(), uId);
                            textController.clear();
                          },
                          icon: Icon(Icons.send))
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
class showComment extends StatelessWidget {
  const showComment({super.key,  required this.cmtData});
  // final Map<String, dynamic> userData;
  final Map<String, dynamic> cmtData;


  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = cmtData['timestamp'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(dateTime);
    int s = duration.inSeconds;
    String? times;
    if (s < 60) {
      String time = "${s}giây";
      times = time;
    } else if (s >= 60 && s < 3600) {
      int p = duration.inMinutes;
      String time = "${p}phút";
      times = time;
    } else if (s >= 3600 && s < 86400) {
      int h = duration.inHours;
      String time = "${h}giờ";
      times = time;
    } else {
      print("Ngày");
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          AvatarCircle(urlImage: 'https://cdn.pixabay.com/photo/2023/07/30/17/00/spider-web-8159315_1280.jpg', widthImage: 50, heightImagel: 50),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Duong",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 5),
              Text(
                cmtData['text'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    times!,

                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

