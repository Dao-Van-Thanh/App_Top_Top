import 'package:app/Provider/comments_provider.dart';
import 'package:app/Services/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/comments/recomment.dart';

class ListRecommets extends StatelessWidget {
  String idVideo;
  String idComment;

  ListRecommets(this.idVideo, this.idComment, {super.key});

  CommentService commentService = CommentService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: commentService.getReCommentsInComment(idVideo, idComment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        final data = snapshot.data?.data() as Map<String, dynamic>;
        var recomments = data['recomments'] as List<dynamic>;
        if (recomments.isNotEmpty) {
          recomments = recomments.reversed.toList();
        }
        return Consumer<CommentsProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                provider.showReComments
                    ? Column(
                        children: recomments
                            .map((e) => ReComment(idVideo, idComment, e))
                            .toList(),
                      )
                    : Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            child: Divider(
                              color: Colors.grey,
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              provider.setShowReComments();
                            },
                            child: Text(
                              "view ${recomments.length}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                provider.showReComments
                    ? Align(
                        child: TextButton(
                          onPressed: () {
                            provider.setShowReComments();
                          },
                          child: const Text(
                            "— Đóng —",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          },
        );
      },
    );
  }
}
