import 'package:app/Provider/comments_provider.dart';
import 'package:app/Services/comment_service.dart';
import 'package:app/View/Pages/comments/showComment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/video_provider.dart';
import 'footerDialog.dart';
import 'footerDialog_temp.dart';

class CommentsDialog extends StatefulWidget {
  const CommentsDialog(
      {Key? key,
      required this.videoId,
      required this.videoProvider,
      required this.commentsSize})
      : super(key: key);
  final String videoId;
  final VideoProvider videoProvider;
  final int commentsSize;

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  ScrollController _scrollController = ScrollController();
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
    return SizedBox(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '${widget.commentsSize} bình luận',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.close), // Nút đóng
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: CommentService().getCommentsInVideo(widget.videoId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    final data =
                        snapshot.data?.data() as Map<String, dynamic>;
                    var comments = data['comments'] as List<dynamic>;
                    if (comments.isEmpty) {
                      return const Center(
                        child: Text("Không có bình luận nào.",
                            style: TextStyle(fontSize: 18)),
                      );
                    }
                    comments = comments.reversed.toList();

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: ChangeNotifierProvider<CommentsProvider>(
                        create: (context) => CommentsProvider(),
                        child: Column(
                          children: comments
                              .map((e) =>
                                  ChangeNotifierProvider<CommentsProvider>(
                                    create: (context) => CommentsProvider(),
                                    child: ShowComment(widget.videoId, e,
                                        widget.videoProvider.blockComments),
                                  ))
                              .toList(), // Chuyển Iterable thành danh sách
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            widget.videoProvider.blockComments
                ? const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Người đăng video này đã chặn comment',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : FooterDialogTemp(
                    avatarURL: avatarURL,
                    videoId: widget.videoId,
                    uId: uId,
                  ),
          ],
        ),
      ),
    );
  }

  Widget inputCustom(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          if (avatarURL != null)
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                avatarURL!,
              ),
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(width: 5),
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
                      padding:
                          const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    FooterDialog(
                                      avatarURL: avatarURL,
                                      videoId: widget.videoId,
                                      uId: uId,
                                    ),
                                    Container(
                                      height: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const TextField(
                          enabled: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Thêm bình luận...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle emoji picker here.
                    },
                    icon: const Icon(Icons.emoji_emotions),
                  ),
                  IconButton(
                    onPressed: () {},
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
