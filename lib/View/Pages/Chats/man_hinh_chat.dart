import 'package:app/Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final chatData = snapshot.data;
          if (chatData != null) {
            final message = chatData.messages;
            final user = FirebaseAuth.instance.currentUser;
            final lsID = service.getIdOtherInListUID(chatData.uid);
            // tự động cuộn xuống cuối
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeOut,);
            });
            return SafeArea(
              child: FutureBuilder<DocumentSnapshot>(
                future: service.getUser(lsID),
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
                              flex: 8,
                              child:_chat(context, snapshot, chatData.messages, user!.uid),
                          ),
                          // ô chat
                          Expanded(
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
                                        await service.addMessageToChat(widget.idPhongChat, editingController.text, user.uid);
                                        editingController.text = '';
                                      },
                                      icon: Icon(Icons.send, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            )
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

  Widget infoOther(BuildContext context, snapshot) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: snapshot.data == null
              ? []
              : [
                  SizedBox(
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
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${snapshot.data!['fullname']}',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
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
    return Container(
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
// child: Row(
//   mainAxisAlignment: check ? MainAxisAlignment.start : MainAxisAlignment.end,
//   children: [
//     Container(
//       height: double.infinity,
//       alignment: Alignment.center,
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: check ? Colors.black12 : Colors.lightBlueAccent,
//           borderRadius: BorderRadius.circular(26)
//       ),
//       child: Text(
//         message.chat,
//         style: TextStyle(
//           color: check ? Colors.black : Colors.white,
//           fontSize: 20
//         ),
//         maxLines: null,
//       ),
//     ),
//   ],
// ),
}
