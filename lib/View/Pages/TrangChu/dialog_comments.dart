import 'package:app/Model/user_model.dart';
import 'package:app/Provider/text_provider.dart';
import 'package:app/Services/comment_service.dart';
import 'package:app/View/Widget/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsDialog extends StatefulWidget {
  final String videoId;
  const CommentsDialog(this.videoId);

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  final user = FirebaseAuth.instance.currentUser;
  late UserModel userModel;
  final textController = TextEditingController();
  String? avatarURL;
  CommentService commentService = CommentService();
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    _getId();
  }

  Future<void> _getId() async {
    CommentService().getAvatarUrl(user!.uid).then((url) {
      setState(() {
        avatarURL = url ?? 'https://cdn.pixabay.com/photo/2023/10/04/02/55/mountains-8292685_640.jpg';
      });
    });
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

          if (comments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50),
                  Text(
                    "Không có bình luận nào.",
                    style: TextStyle(fontSize: 18),
                  ),
                  footerDialog(avatarURL!, widget.videoId),
                ],
              ),
            );
          }

          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: comments.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final reversedComments = comments.reversed.toList();
                      return ShowComment(cmtData: reversedComments[index]);
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        footerDialog(avatarURL!, widget.videoId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget footerDialog(String urlImage, String videoId) {
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
                  return avatarURL != null
                      ? AvatarCircle(
                    urlImage: urlImage,
                    widthImage: 50,
                    heightImagel: 50,
                  )
                      : CircularProgressIndicator();
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
                            // isEmoji = !isEmoji;
                          });
                        },
                        icon: Icon(Icons.emoji_emotions),
                      ),
                      IconButton(
                        onPressed: () {
                          CommentService().sendCmt(
                              videoId, textController.text.trim(), user!.uid);
                          textController.clear();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowComment extends StatelessWidget {
  const ShowComment({required this.cmtData});

  final Map<String, dynamic> cmtData;

  @override
  Widget build(BuildContext context) {
    final relineComment = Provider.of<TextProvider>(context);
    Timestamp timestamp = cmtData['timestamp'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(dateTime);
    int s = duration.inSeconds;
    String? times;

    if (s < 60) {
      String time = "${s} giây";
      times = time;
    } else if (s >= 60 && s < 3600) {
      int p = duration.inMinutes;
      String time = "${p} phút";
      times = time;
    } else if (s >= 3600 && s < 86400) {
      int h = duration.inHours;
      String time = "${h} giờ";
      times = time;
    } else {
      int day = duration.inDays;
      String time = "${day} ngày";
      times = time;
    }

    return Column(
      children: [
        FutureBuilder<UserModel?>(
          future: CommentService().getUserDataForUid(cmtData['uid']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              UserModel? userModel = snapshot.data != null ? snapshot.data! : null;
              return Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    AvatarCircle(
                      urlImage: userModel!.avatarURL,
                      widthImage: 50,
                      heightImagel: 50,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.fullName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                            cmtData['text'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              times ?? '',
                            ),
                            TextButton(
                              onPressed: () {
                                relineComment.isFullText();
                              },
                              child: Text("Trả lời", style: TextStyle(color: Colors.black)),
                            ),

                          ],
                        ),
                            DividerRow(),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class DividerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 20,
              child: Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
            SizedBox(width: 5),
            TextButton(
              onPressed: () {},
              child: Text(
                "Xem 5 câu trả lời",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
