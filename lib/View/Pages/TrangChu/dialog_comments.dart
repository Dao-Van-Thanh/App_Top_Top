import 'package:flutter/material.dart';

import '../../../Provider/video_provider.dart';
import '../../../Services/comment_service.dart';
import '../../Widget/avatar.dart';

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
    required this.videoProvider,
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
                  ),
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
