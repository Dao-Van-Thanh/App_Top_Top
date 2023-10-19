import 'dart:io';

import 'package:app/Services/chat_service.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Model/chat_model.dart';

class ManHinhChat extends StatefulWidget {
  String idPhongChat;
  ManHinhChat(this.idPhongChat);

  @override
  State<ManHinhChat> createState() => _ManHinhChatState();
}

class _ManHinhChatState extends State<ManHinhChat> {
  ChatService service = ChatService();
  ScrollController _controller = ScrollController();
  TextEditingController editingController = TextEditingController();
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
            final message = chatData.messages;
            final user = FirebaseAuth.instance.currentUser;
            final idOther = service.getIdOtherInListUID(chatData.uid);
            // tự động cuộn xuống cuối
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeOut,);
            });
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
                          Navigator.of(context).pop(); // Để quay lại màn hình trước đó
                        },
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (snapshot.data != null &&
                              snapshot.data!['avatarURL'] != null)
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage: NetworkImage(snapshot.data!['avatarURL']),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (snapshot.data != null &&
                              snapshot.data!['fullname'] != null)
                            Container(
                              child: Text(
                                '${snapshot.data!['fullname']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
                              flex: 2,
                              child:_chat(context, snapshot, chatData.messages, user!.uid),
                          ),
                          // ô chat
                          SingleChildScrollView(
                            child: Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.attachment,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          showImagePicker(context,chatData.id);
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          controller: editingController,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            hintText: 'Nhập tin nhắn...',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if(editingController.text.isNotEmpty)
                                          await service.addMessageToChat(widget.idPhongChat, editingController.text, user.uid);
                                          editingController.text = '';
                                        },
                                        icon: Icon(Icons.send, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
            return Text('Không có dữ liệu cho phòng chat này.');
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
  void showImagePicker(BuildContext context,String idPhongChat) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Chọn ảnh từ thư viện'),
              onTap: () async {
                await ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((xfile) => {
                        if(xfile != null){
                          service.uploadFileToChat(file: File(xfile.path), idPhongChat: idPhongChat)
                        }
                    }
                );
                Navigator.pop(context);

              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Chụp ảnh mới'),
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
    return Container(
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
                  Container(
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
    bool check = message.idUserChat != uid;
    return GestureDetector (
      onLongPress: () {
        //kiểm tra nếu đúng là mình chat thì có quyền xóa chat đó
        !check ? showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)
                )
            ),
            context: context,
            builder: (context) {
              return _showModelOptions(context,widget.idPhongChat, message.idChat);
            },
        ) : null;
        //
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Align(
          alignment: check ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width), // Đặt kích thước tối đa
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: check ? Colors.black12 : Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Text(
              message.chat,
              style: TextStyle(
                color: check ? Colors.black : Colors.white,
                fontSize: 20,
              ),
              maxLines: null,
            ),
          ),
        ),
      ),
    );
  }
  Widget _chat(BuildContext context,snapshot,List<Message> messages,String uid){
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: [
          infoOther(context, snapshot),
          for (var message in messages)
            _itemChat(context, message,uid),
        ],
      ),
    );
  }
  Widget _showModelOptions(BuildContext context,String phongChat,String idChat){
    return Container(
      height: MediaQuery.of(context).size.height*0.12,
      alignment: Alignment.center,
      child: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(90)),
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
                  style: TextStyle(
                    color: Colors.red
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
