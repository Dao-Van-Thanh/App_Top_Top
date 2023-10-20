import 'package:app/Model/user_model.dart';
import 'package:app/Provider/emoji_provider.dart';
import 'package:app/Services/comment_service.dart';
import 'package:app/View/Pages/comments/showComment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/video_provider.dart';
import 'footerDialog.dart';

class CommentsDialog extends StatefulWidget {
  const CommentsDialog(
      {Key? key, required this.videoId, required this.videoProvider})
      : super(key: key);
  final String videoId;
  final VideoProvider videoProvider;

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
          const SizedBox(height: 5),
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
                  final comments = data['comments'] as List<dynamic>;
                  if (comments.isEmpty) {
                    return const Center(
                      child: Text("Không có bình luận nào.",
                          style: TextStyle(fontSize: 18)),
                    );
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final reversedComments = comments.reversed.toList();
                      return ShowComment(
                          cmtData: reversedComments[index],
                          videoId: widget.videoId,
                          uid: uId);
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
                  avatarURL:
                      'https://cdn.pixabay.com/photo/2016/02/13/13/11/oldtimer-1197800_1280.jpg',
                  videoId: widget.videoId,
                  textController: textController,
                  uId: uId,
                  videoProvider: widget.videoProvider),
            ),
          ),
        ],
      ),
    );
  }
}


