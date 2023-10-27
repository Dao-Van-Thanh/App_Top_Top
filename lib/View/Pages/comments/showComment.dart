import 'package:app/Model/comment_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/comments/notifileDelete.dart';
import 'package:app/View/Pages/comments/recomment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/user_model.dart';
import '../../../Provider/emoji_provider.dart';
import '../../../Services/comment_service.dart';

class ShowComment extends StatelessWidget {
  String idComment;
  String idVideo;
  bool blockComments;

  ShowComment(this.idVideo, this.idComment, this.blockComments);

  @override
  Widget build(BuildContext context) {
    CommentService commentService = CommentService();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    Offset tapDownPosition = Offset.zero;

    TextEditingController controllerSuaComment = TextEditingController();

    return StreamBuilder<DocumentSnapshot>(
      stream: commentService.getCommentById(idVideo, idComment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        CommentModel commentModel = CommentModel.fromSnapshot(
            snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
        bool check = commentModel.uid == uid;
        EmojiProvider emojiProvider = EmojiProvider();
        String time =
            UserService.formattedTimeAgo(commentModel.timestamp.toDate());
        bool isLiked = commentModel.likes.contains(uid);

        return StreamBuilder<DocumentSnapshot>(
          stream: UserService().getUser(commentModel.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(); // Hiển thị tiêu đề tải dữ liệu
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              UserModel? userModel = UserModel.fromSnap(
                  snapshot.data as DocumentSnapshot<Map<String, dynamic>>);

              return GestureDetector(
                onTapDown: (TapDownDetails details) {
                  tapDownPosition = details.globalPosition;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onLongPress: () {
                  showMenu(
                      context: context,
                      position: RelativeRect.fromRect(
                          Rect.fromLTWH(
                              tapDownPosition.dx, tapDownPosition.dy, 30, 30),
                          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                              overlay.paintBounds.size.height)),
                      items: [
                        if (check)
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: const Text('Xóa'),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => NotifiDelete(
                                      videoId: idVideo, cmtId: idComment));
                            },
                          ),
                        if (check)
                          PopupMenuItem(
                            child: Text('Chỉnh sửa bình luận'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        TextField(
                                            controller: controllerSuaComment,
                                            decoration: InputDecoration(
                                                hintText:
                                                    '${commentModel.text}')),
                                        TextButton(
                                            onPressed: () {
                                              if (controllerSuaComment.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                commentService.updateComment(
                                                  idVideo,
                                                  idComment,
                                                  controllerSuaComment.text
                                                      .trim(),
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text('Sửa'))
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        const PopupMenuItem<String>(
                          value: 'repost',
                          child: Text('Repost'),
                        ),
                      ]);
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(
                          userModel.avatarURL ?? '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.fullName ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              commentModel.text ?? '',
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
                                  time ?? '',
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (!blockComments) {
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height * 0.6,
                                            child:
                                                ReComment(idVideo, idComment),
                                          );
                                        },
                                      );
                                    }
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
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () => {
                                        commentService.likeComment(
                                            idVideo, idComment, isLiked)
                                      },
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  )),
                              Text('${commentModel.likes.length}')
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
