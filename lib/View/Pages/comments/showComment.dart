import 'package:app/Model/comment_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/comments/footer_dialog_recomment.dart';
import 'package:app/View/Pages/comments/notifileDelete.dart';
import 'package:app/View/Widget/list_recomments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/comments_provider.dart';
import '../../../Services/comment_service.dart';

class ShowComment extends StatelessWidget {
  String idComment;
  String idVideo;
  bool blockComments;

  ShowComment(this.idVideo, this.idComment, this.blockComments, {super.key});

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
        String time =
        UserService.formattedTimeAgo(commentModel.timestamp.toDate());
        bool isLiked = commentModel.likes.contains(uid);
        return StreamBuilder<DocumentSnapshot>(
          stream: UserService().getUser(commentModel.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data == null
                  ? const SizedBox()
                  : Consumer<CommentsProvider>(
                builder: (context, provider, child) {
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
                              Rect.fromLTWH(tapDownPosition.dx,
                                  tapDownPosition.dy, 30, 30),
                              Rect.fromLTWH(
                                  0,
                                  0,
                                  overlay!.paintBounds.size.width,
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
                                          videoId: idVideo,
                                          cmtId: idComment));
                                },
                              ),
                            if (check)
                              PopupMenuItem(
                                child: const Text('Chỉnh sửa bình luận'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            TextField(
                                                controller:
                                                controllerSuaComment,
                                                decoration: InputDecoration(
                                                    hintText:
                                                    commentModel.text)),
                                            TextButton(
                                                onPressed: () {
                                                  if (controllerSuaComment
                                                      .text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    commentService
                                                        .updateComment(
                                                      idVideo,
                                                      idComment,
                                                      controllerSuaComment
                                                          .text
                                                          .trim(),
                                                    );
                                                    Navigator.pop(
                                                        context);
                                                  }
                                                },
                                                child: const Text('Sửa'))
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
                              snapshot.data?['avatarURL'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?['fullname'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  commentModel.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  maxLines:
                                  null, // Để cho phép xuống dòng
                                  softWrap:
                                  true, // Cho phép tự động xuống dòng khi cần
                                ),
                                Row(
                                  children: [
                                    Text(
                                      time,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (!blockComments) {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    FooterDialogReComment(
                                                        nameUserReComment:
                                                        snapshot.data?[
                                                        'fullname'] ??
                                                            '',
                                                        idComment:
                                                        idComment,
                                                        videoId: idVideo,
                                                        uId: uid),
                                                    Container(
                                                      height:
                                                      MediaQuery.of(
                                                          context)
                                                          .viewInsets
                                                          .bottom,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Trả lời",
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                commentModel.recomments.isEmpty
                                    ? const SizedBox.shrink()
                                    : ListRecommets(idVideo, idComment)
                              ],
                            ),
                          ),
                          //like
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () => {
                                        commentService.likeComment(
                                            idVideo,
                                            idComment,
                                            isLiked)
                                      },
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                      )),
                                  Text('${commentModel.likes.length}')
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
