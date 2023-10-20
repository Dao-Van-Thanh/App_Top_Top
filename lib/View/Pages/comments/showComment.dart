import 'package:app/View/Pages/comments/notifileDelete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/user_model.dart';
import '../../../Provider/emoji_provider.dart';
import '../../../Services/comment_service.dart';

class ShowComment extends StatelessWidget {
  final Map<String, dynamic> cmtData;

  ShowComment(
      {required this.cmtData, required this.videoId, required this.uid});

  final String videoId;
  final String? uid;


  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = cmtData['timestamp'];
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(dateTime);
    int s = duration.inSeconds;
    String? times;

    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    Offset tapDownPosition = Offset.zero;

    String avarTest =
        'https://cdn.pixabay.com/photo/2016/02/13/13/11/oldtimer-1197800_1280.jpg';

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
          bool check = cmtData['uid'] == uid;
          EmojiProvider emojiProvider = EmojiProvider();
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              tapDownPosition = details.globalPosition;
            },
            onLongPress: (){
              showMenu(context: context,
                  position: RelativeRect.fromRect(
                      Rect.fromLTWH(tapDownPosition.dx,
                          tapDownPosition.dy, 30, 30),
                      Rect.fromLTWH(0, 0,
                          overlay!.paintBounds.size.width,
                          overlay.paintBounds.size.height)),
                  items: [
                    if(check)
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: const Text('Xóa'),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => NotifiDelete(videoId: videoId, cmtId: cmtData['id']));
                        },
                      ),
                    if(check)
                      PopupMenuItem(
                        child: Text('Chỉnh sửa bình luận'),
                        onTap: () {

                        },

                      ),
                    const PopupMenuItem<String>(
                      value: 'repost',
                      child: Text('Repost'),
                    ),
                  ]
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                      userModel!.avatarURL,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cmtData['text'] ?? '',
                          style: const TextStyle(
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
                                emojiProvider.checkRepline(true);
                                emojiProvider.setCmt(cmtData['uid']);
                              },
                              child: const Text(
                                "Trả lời",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  child: const Divider(
                                    color: Colors.grey,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    // Xử lý hành động View Replies ở đây.
                                    emojiProvider.onEmjiPicker();
                                  },
                                  child: const Text(
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
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}