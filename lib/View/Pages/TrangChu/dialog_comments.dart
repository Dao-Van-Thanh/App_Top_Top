import 'package:app/Model/user_model.dart';
import 'package:app/Services/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsDialog extends StatefulWidget {
  const CommentsDialog({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  final textController = TextEditingController();
  String? avatarURL;
  CommentService commentService = CommentService();
  String? uId;
  bool checkLogin = false;

  @override
  void initState() {
    super.initState();
    _getId();
  }

  Future<void> _getId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uId = user.uid;
        checkLogin = true;
      });
      CommentService().getAvatarUrl(uId!).then((url) {
        if (url != null) {
          setState(() {
            avatarURL = url;
          });
        }
      });
    } else {
      setState(() {
        checkLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: StreamBuilder<DocumentSnapshot>(
              stream: CommentService().getCmtVideo(widget.videoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final data = snapshot.data?.data() as Map<String, dynamic> ?? {};
                  final comments = data?['comments'] as List<dynamic>;
                  if (comments.isEmpty) {
                    return Center(
                      child: Text("Không có bình luận nào.", style: TextStyle(fontSize: 18)),
                    );
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final reversedComments = comments.reversed.toList();
                      return ShowComment(cmtData: reversedComments[index]);
                    },
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child: Expanded(
              flex: 3,
              child: FooterDialog(avatarURL: 'https://cdn.pixabay.com/photo/2023/08/29/19/42/goose-8222013_640.jpg', videoId: widget.videoId, textController: textController, uId: uId),
            ),
          ),
        ],
      ),
    );
  }
}

class FooterDialog extends StatelessWidget {
  final String? avatarURL;
  final String videoId;
  final TextEditingController textController;
  final String? uId;

  FooterDialog({required this.avatarURL, required this.videoId, required this.textController, required this.uId});

  @override
  Widget build(BuildContext context) {
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
                future: precacheImage(NetworkImage(avatarURL!), context),
                builder: (context, snapshot) {
                  return avatarURL != null
                      ? AvatarCircle(
                    urlImage: avatarURL!,
                    widthImage: 50,
                    heightImage: 50,
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
                          padding: const EdgeInsets.all(5),
                          child: TextField(
                            maxLines: null,
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Thêm bình luận...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle emoji picker here.
                        },
                        icon: Icon(Icons.emoji_emotions),
                      ),
                      IconButton(
                        onPressed: () {
                          CommentService().sendCmt(videoId, textController.text.trim(), uId!);
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
  final Map<String, dynamic> cmtData;

  ShowComment({required this.cmtData});

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = cmtData['timestamp'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(dateTime);
    int s = duration.inSeconds;
    String? times;
    String avarTest ='https://cdn.pixabay.com/photo/2023/08/29/19/42/goose-8222013_640.jpg';

    if (s < 60) {
      String time = "${s} seconds";
      times = time;
    } else if (s >= 60 && s < 3600) {
      int p = duration.inMinutes;
      String time = "${p} minutes";
      times = time;
    } else if (s >= 3600 && s < 86400) {
      int h = duration.inHours;
      String time = "${h} hours";
      times = time;
    } else {
      int day = duration.inDays;
      String time = "${day} days";
      times = time;
    }

    return FutureBuilder<UserModel?>(
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
                  urlImage: avarTest,
                  widthImage: 50,
                  heightImage: 50,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel!.fullName,
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
                            // Handle reply action here.
                          },
                          child: Text(
                            "Reply",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
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
                          onPressed: () {
                            // Handle view replies action here.
                          },
                          child: Text(
                            "View 5 replies",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final String urlImage;
  final double widthImage;
  final double heightImage;

  AvatarCircle({
    required this.urlImage,
    required this.widthImage,
    required this.heightImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widthImage / 2),
      child: Image.network(
        urlImage,
        width: widthImage,
        height: heightImage,
        fit: BoxFit.cover,
      ),
    );
  }
}