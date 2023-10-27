import 'package:app/Services/comment_service.dart';
import 'package:app/View/Pages/comments/showComment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Provider/video_provider.dart';
import 'footerDialog.dart';

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
  final textController = TextEditingController();
  String? avatarURL;
  CommentService commentService = CommentService();
  String? uId;
  bool checkLogin = false;
  double _scrollPosition = 0.0;
  bool _scrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _getId();
    // Lắng nghe sự kiện cuộn
    _scrollController.addListener(() {
      _scrollPosition = _scrollController.position.pixels;
    });
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
                      snapshot.data?.data() as Map<String, dynamic> ?? {};
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
                    child: Column(
                      children: comments
                          .map((e) => ShowComment(widget.videoId, e,widget.videoProvider.blockComments))
                          .toList(), // Chuyển Iterable thành danh sách
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                    ),
                  ),
              )
              : FooterDialog(
                  avatarURL: avatarURL,
                  videoId: widget.videoId,
                  textController: textController,
                  uId: uId,
                  videoProvider: widget.videoProvider),
        ],
      ),
    );
  }
}
