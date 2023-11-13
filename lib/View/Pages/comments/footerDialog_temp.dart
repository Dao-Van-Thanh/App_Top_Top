import 'package:flutter/material.dart';

import '../../../Provider/comments_provider.dart';
import 'footerDialog.dart';

class FooterDialogTemp extends StatefulWidget {
  final String? avatarURL;
  final String videoId;
  final String? uId;

  // final VideoProvider videoProvider;

  const FooterDialogTemp(
      {super.key, required this.avatarURL,
      required this.videoId,
      required this.uId,
      // required this.videoProvider
      });

  @override
  State<FooterDialogTemp> createState() => _FooterDialogState();
}

class _FooterDialogState extends State<FooterDialogTemp> {
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
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    FooterDialog(
                                        avatarURL: widget.avatarURL,
                                        videoId: widget.videoId,
                                        uId: widget.uId,
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
                          enabled: false,
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
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                FooterDialog(
                                  avatarURL: widget.avatarURL,
                                  videoId: widget.videoId,
                                  uId: widget.uId,
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
                    icon: const Icon(Icons.emoji_emotions),
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.send),
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
