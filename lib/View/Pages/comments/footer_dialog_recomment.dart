import 'package:flutter/material.dart';

import '../../../Provider/comments_provider.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/comment_service.dart';

class FooterDialogReComment extends StatefulWidget {
  final String videoId;
  final String uId;
  final String idComment;
  final String nameUserReComment;

  FooterDialogReComment({
    required this.idComment,
    required this.videoId,
    required this.uId,
    required this.nameUserReComment,
  });

  @override
  State<FooterDialogReComment> createState() => _FooterDialogReCommentState();
}

class _FooterDialogReCommentState extends State<FooterDialogReComment> {
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
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
                            padding: const EdgeInsets.only(
                                left: 20, top: 5, bottom: 5),
                            child: TextField(
                              maxLines: null,
                              focusNode: myFocusNode,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                hintText:
                                    'Trả lời bình luận của ${widget.nameUserReComment}...',
                                border: InputBorder.none,
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
                          onPressed: () {
                            CommentService().sendReComment(
                                widget.videoId,
                                widget.idComment,
                                textEditingController.text.trim(),
                                widget.uId);
                            textEditingController.clear();
                            Navigator.pop(context);
                            // int index = videoProvider.listVideo
                            //     .indexWhere((element) => element == videoId);
                            // videoProvider.listVideo[index].comments.add('');
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
      ),
    );
  }
}
