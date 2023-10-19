import 'package:app/Model/user_model.dart';
import 'package:app/Services/comment_service.dart';
import 'package:flutter/material.dart';

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
          SizedBox(height: 5),
          Expanded(
            flex: 2,
            child: StreamBuilder<DocumentSnapshot>(
              stream: CommentService().getCmtVideo(widget.videoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final data =
                      snapshot.data?.data() as Map<String, dynamic> ?? {};
                  final comments = data?['comments'] as List<dynamic>;
                  if (comments.isEmpty) {
                    return Center(
                      child: Text("Không có bình luận nào.",
                          style: TextStyle(fontSize: 18)),
                    );
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final reversedComments = comments.reversed.toList();
                      return ShowComment(cmtData: reversedComments[index],videoId: widget.videoId);
                    },
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child: Expanded(
              flex: 1,
              child: FooterDialog(
                  avatarURL: avatarURL,
                  videoId: widget.videoId,
                  textController: textController,
                  uId: uId),
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
  final VideoProvider videoProvider;

  FooterDialog({
    required this.avatarURL,
    required this.videoId,
    required this.textController,
    required this.uId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          if (avatarURL != null)
            AvatarCircle(
              urlImage: avatarURL!,
              widthImage: 50,
              heightImagel: 50,
            )
          else
            CircularProgressIndicator(),
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
                      padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: TextField(
                        maxLines: null,
                        controller: textController,
                        decoration: const InputDecoration(
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
                  IconButton(
                    onPressed: () {
                      CommentService().sendCmt(videoId, textController.text.trim(), uId!);
                      int index = videoProvider.listVideo.indexWhere((element) => element == videoId);
                      videoProvider.listVideo[index].comments.add('');
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
    );
  }
}
class ShowComment extends StatelessWidget {
  final Map<String, dynamic> cmtData;

  ShowComment({required this.cmtData, required this.videoId});
  final String videoId;

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = cmtData['timestamp'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(dateTime);
    int s = duration.inSeconds;
    String? times;
    // String avarTest = 'https://cdn.pixabay.com/photo/2016/02/13/13/11/oldtimer-1197800_1280.jpg';

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
          return Container(); // Hiển thị tiêu đề tải dữ liệu
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          UserModel? userModel = snapshot.data;

          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AvatarCircle(
                  urlImage: userModel!.avatarURL,
                  widthImage: 50,
                  heightImage: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel?.fullName ?? 'Unknown User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        cmtData['text'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            times ?? '',
                          ),
                          TextButton(
                            onPressed: () {
                              // Xử lý hành động Reply ở đây.
                            },
                            child: Text(
                              "Trả lời",
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
                              // Xử lý hành động View Replies ở đây.
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
                ),
                // Center(
                //     child: GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) {
                //         return NotifiDelete();
                //       },
                //     );
                //   },
                //   child: Image.asset(
                //     'assets/dots.png',
                //     height: 20,
                //     width: 20,
                //   ),
                // )),
                Center(
                  child: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Xóa'),
                        ),
                      ];
                    },
                    onSelected: (String choice) {
                      if (choice == 'delete') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return NotifiDelete(videoId: videoId,cmtId: cmtData['id']);
                            },);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class NotifiDelete extends StatelessWidget {
  const NotifiDelete({super.key, required this.videoId, required this.cmtId});
  final String videoId;
  final String cmtId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 4.5,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Bạn có chắc chắn muốn \n xóa comment ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Divider(color: Colors.grey),
                  TextButton(
                      onPressed: () {
                        CommentService().deleteCmt(videoId, cmtId);
                      },
                      child: Center(
                          child: Text('Xóa',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.black)))),
                  SizedBox(height: 5),
                  Divider(color: Colors.grey),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                          child: Text('Hủy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey)))),
                ],
              ),
            ),
          ),
        ]);
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
