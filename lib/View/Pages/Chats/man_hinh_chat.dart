import 'dart:io';
import 'package:app/Provider/chats_provider.dart';
import 'package:app/Services/notifications_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:app/Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Model/chat_model.dart';

class ManHinhChat extends StatefulWidget {
  String idPhongChat;

  ManHinhChat(this.idPhongChat, {super.key});

  @override
  State<ManHinhChat> createState() => _ManHinhChatState();
}

class _ManHinhChatState extends State<ManHinhChat> {
  ChatService service = ChatService();
  final ScrollController _controller = ScrollController();
  TextEditingController editingController = TextEditingController();
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ChatsProfiver>(context,listen: false);
    provider.emojiShowing = false;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.getChatDataStream(widget.idPhongChat),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final chatData = snapshot.data;
          if (chatData != null) {
            final user = FirebaseAuth.instance.currentUser;
            final idOther = service.getIdOtherInListUID(chatData.uid);
            NotificationsService notificationsService = NotificationsService();
            // tự động cuộn xuống cuối
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeOut,
              );
            });
            final provider = Provider.of<ChatsProfiver>(context);
            return SafeArea(
              child: FutureBuilder<DocumentSnapshot>(
                future: service.getUser(idOther),
                builder: (context, snapshot) {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Để quay lại màn hình trước đó
                        },
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (snapshot.data != null &&
                              snapshot.data!['avatarURL'] != null)
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(snapshot.data!['avatarURL']),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (snapshot.data != null &&
                              snapshot.data!['fullname'] != null)
                            Text(
                              '${snapshot.data!['fullname']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => {
                                provider.setEmojiShowing(false),
                                FocusScope.of(context).requestFocus(FocusNode())
                              },
                              child: _chat(context, snapshot, chatData.messages,
                                  user!.uid),
                            ),
                          ),
                          // ô chat
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.attachment,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              showImagePicker(
                                                  context, chatData.id);
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: TextField(
                                              controller: editingController,
                                              maxLines: null,
                                              decoration:
                                                  const InputDecoration(
                                                hintText:
                                                    'Nhập tin nhắn...',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              provider.setEmojiShowing(!provider.emojiShowing);
                                            },
                                            icon: const Icon(
                                              Icons.tag_faces_sharp,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (editingController
                                          .text.trim().isNotEmpty) {
                                        String chat = editingController.text;
                                        editingController.text = '';
                                        final check = await service.addMessageToChat(
                                            widget.idPhongChat,
                                            chat,
                                            user.uid);
                                        if(check){
                                          final checkOnline =
                                              await UserService
                                                  .checkUserOnline(uid: idOther);
                                          if(!checkOnline){
                                            notificationsService.sendNotification(
                                                title: 'Tin nhăn mới từ ${snapshot.data!['fullname'] ?? 'người dùng'} ',
                                                body: chat,
                                                idOther: idOther
                                            );
                                          }
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.send,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
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
                                textEditingController: editingController,
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
              ),
            );
          } else {
            return const Text('Không có dữ liệu cho phòng chat này.');
          }
        }
      },
    );
  }

  Future<XFile?> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final PlatformFile file = result.files.single;
      return XFile(file.path!);
    }
    return null;
  }

  void showImagePicker(BuildContext context, String idPhongChat) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn ảnh từ thư viện'),
              onTap: () async {
                await ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((xfile) => {
                          if (xfile != null)
                            {
                              service.uploadFileToChat(
                                  file: File(xfile.path),
                                  idPhongChat: idPhongChat)
                            }
                        });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Chụp ảnh mới'),
              onTap: () {
                Navigator.pop(context);
                // Gọi hàm chụp ảnh ở đây
              },
            ),
          ],
        );
      },
    );
  }

  Widget infoOther(BuildContext context, snapshot) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: snapshot.data == null
              ? []
              : [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          NetworkImage(snapshot.data!['avatarURL']),
                    ),
                  ),
                  Text(
                    '${snapshot.data!['fullname']}',
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${snapshot.data!['idTopTop']}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    '${snapshot.data!['following'].length} đang follow   '
                    '${snapshot.data!['follower'].length} follower',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ]),
    );
  }

  Widget _itemChat(BuildContext context, Message message, String uid) {
    bool checkNguoiChat = message.idUserChat != uid;
    bool checkURI = Uri.parse(message.chat).isAbsolute;

    return GestureDetector(
      onLongPress: () {
        //kiểm tra nếu đúng là mình chat thì có quyền xóa chat đó
        !checkNguoiChat
            ? showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                context: context,
                builder: (context) {
                  return _showModelOptions(
                      context, widget.idPhongChat, message.idChat);
                },
              )
            : null;
        //
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Align(
          alignment:
              checkNguoiChat ? Alignment.centerLeft : Alignment.centerRight,
          child: checkURI
              ? InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.black,
                          child: Image.network(
                            message.chat,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 200, // Độ rộng của hình chữ nhật
                    height: 300, // Độ cao của hình chữ nhật
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black), // Viền đen
                      borderRadius: BorderRadius.circular(
                          10), // Bo góc để tạo hì nh chữ nhật
                    ),
                    child: Image.network(message
                        .chat), // Thay 'assets/your_image.png' bằng đường dẫn đến hình ảnh của bạn
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context)
                          .size
                          .width), // Đặt kích thước tối đa
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: checkNguoiChat
                        ? Colors.black12
                        : Colors.lightBlueAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(checkNguoiChat ? 0 : 26),
                        bottomRight: Radius.circular(checkNguoiChat ? 26 : 0),
                        topRight: const Radius.circular(26),
                        topLeft: const Radius.circular(26)),
                  ),
                  child: Text(
                    message.chat,
                    style: TextStyle(
                      color: checkNguoiChat ? Colors.black : Colors.white,
                      fontSize: 20,
                    ),
                    maxLines: null,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _chat(
      BuildContext context, snapshot, List<Message> messages, String uid) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: [
          infoOther(context, snapshot),
          for (var message in messages) _itemChat(context, message, uid),
        ],
      ),
    );
  }

  Widget _showModelOptions(
      BuildContext context, String phongChat, String idChat) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      alignment: Alignment.center,
      child: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(90)),
          onTap: () async {
            await service.deleteMessageByChatId(phongChat, idChat);
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
              Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
