import 'package:app/Model/user_model.dart';
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
  final String videoId;
  const CommentsDialog(this.videoId, {Key? key}) : super(key: key);

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  String uId = '';
  bool checkLogin = false;
  final textController = TextEditingController();
  bool isEmoji = false;
  String? avatarURL;
  late UserModel userModel ;
  CommentService commentService = CommentService();
  
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
      CommentService().getAvatarUrl(uId).then((url) {
        setState(() {
          avatarURL = url;
        });
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
      stream: CommentService().getCmtVideo(widget.videoId),
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
            return Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 50),
                        Text("Không có bình luận nào.",
                            style: TextStyle(fontSize: 18)),
                        Positioned(
                          bottom: 0,
                          child:
                          footerDialog(
                              avatarURL!,
                              widget.videoId),
                        ),
                      ],
                    ),
                  )
                ],
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
                              avatarURL!,
                              widget.videoId),
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
              FutureBuilder(
                  future: precacheImage(NetworkImage(urlImage), context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AvatarCircle(
                      urlImage: urlImage,
                      widthImage: 50,
                      heightImagel: 50,
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Icon(Icons.error);
                  }
                },
              ),
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
    String uid = cmtData['uid'];
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
    Future<UserModel?> getUserModel() async {
      return CommentService().getUserDataForUid(cmtData['uid']);
    }
    return FutureBuilder<UserModel?>(
        future: getUserModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: Colors.white);
          } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
          } else {
            UserModel userModel = snapshot.data!;
            return Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  AvatarCircle(urlImage: userModel.avatarURL, widthImage: 50, heightImagel: 50),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.fullName,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        cmtData['text']?? '',
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
                            times?? '',

                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        },
    );
  }
}


