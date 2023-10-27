import 'package:flutter/material.dart';

import '../../../Provider/comments_provider.dart';
import '../../../Provider/video_provider.dart';
import '../../../Services/comment_service.dart';

class FooterDialog extends StatefulWidget {
  final String? avatarURL;
  final String videoId;
  final String? uId;
  // final VideoProvider videoProvider;

  FooterDialog(
      {required this.avatarURL,
      required this.videoId,
      required this.uId,
      // required this.videoProvider
      });

  @override
  State<FooterDialog> createState() => _FooterDialogState();
}

class _FooterDialogState extends State<FooterDialog> {
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    CommentsProvider setComment = CommentsProvider();
    bool check = setComment.reline;
    TextEditingController textEditingController = TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          if (widget.avatarURL != null)
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                widget.avatarURL!,
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
                      child: TextField(
                        focusNode: myFocusNode,
                        maxLines: null,
                        controller: textEditingController,
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
                    icon: const Icon(Icons.emoji_emotions),
                  ),
                  IconButton(
                    onPressed: () {
                      CommentService()
                          .sendComment(widget.videoId, textEditingController.text.trim(), widget.uId!);
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
    );
  }
}
