import 'package:app/Provider/chats_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../../../Services/comment_service.dart';

class FooterDialogReComment extends StatefulWidget {
  final String videoId;
  final String uId;
  final String idComment;
  final String nameUserReComment;

  const FooterDialogReComment({super.key, 
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
    final provider = Provider.of<ChatsProfiver>(context,listen: false);
    provider.emojiShowing = false;
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Consumer<ChatsProfiver>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
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
                                  if(provider.emojiShowing){
                                    myFocusNode.requestFocus();
                                  }else{
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }
                                  provider.setEmojiShowing(!provider.emojiShowing);
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
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !provider.emojiShowing,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: EmojiPicker(
                      // onEmojiSelected: (Category category, Emoji emoji) {
                      //   // Do something when emoji is tapped (optional)
                      // },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: textEditingController,
                      // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(
                              fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        // Needs to be const Widget
                        loadingIndicator: const SizedBox.shrink(),
                        // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
