import 'package:app/Model/chat_model.dart';
import 'package:app/Model/user_model.dart';
import 'package:app/Provider/chats_provider.dart';
import 'package:app/Services/chat_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Chats/man_hinh_chat.dart';
import 'package:app/View/Widget/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManHinhHopThu extends StatelessWidget {
  ChatService service = ChatService();

  @override
  Widget build(BuildContext context) {
    ChatService service = ChatService();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Hộp thư',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ChatModel>>(
          stream: service.getChatsByUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('${snapshot.error} ======================');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              String? uid = FirebaseAuth.instance.currentUser?.uid;
              List<ChatModel>? ls = snapshot.data;
              ls?.sort((a, b) {
                // Lấy tin nhắn cuối cùng trong mỗi phòng chat (nếu có)
                final aLastMessage = a.messages.isNotEmpty
                    ? a.messages.last.timestamp
                    : DateTime(0);
                final bLastMessage = b.messages.isNotEmpty
                    ? b.messages.last.timestamp
                    : DateTime(0);
                // Sắp xếp giảm dần (từ mới đến cũ)
                return bLastMessage.compareTo(aLastMessage);
              });

              return ListView.builder(
                itemCount: ls?.length,
                itemBuilder: (context, index) {
                  String? chat;
                  String? idUserChat = '';
                  try {
                    chat =
                        ls?[index].messages[ls[index].messages.length - 1].chat;
                    idUserChat = ls?[index]
                        .messages[ls[index].messages.length - 1]
                        .idUserChat;
                  } catch (e) {
                    chat = '';
                    idUserChat = '';
                  }
                  return _itemGroupChat(
                      context, ls![index], chat ?? '', idUserChat!, uid!);
                  // return Text('data');
                },
              );
            }
          }),
    ));
  }

  Widget _itemGroupChat(BuildContext context, ChatModel model, String chat,
      String idUserChat, String uid) {
    String idOther = service.getIdOtherInListUID(model.uid);
    UserService userService = UserService();
    return StreamBuilder<DocumentSnapshot>(
        stream: userService.getUser(idOther),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('${snapshot.error} ======================');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserModel userModel = UserModel.fromSnap(snapshot.data!);
            bool checkFollow = userModel.following!.contains(uid) &&
                userModel.follower!.contains(uid);
            Timestamp timestamp = snapshot.data!['lastActive'];
            String lastActive = UserService.formattedTimeAgo(timestamp.toDate());
            return InkWell(
              onTap: () {
                if (checkFollow) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManHinhChat(model.id),
                      ));
                } else {
                  SnackBarWidget.showSnackbar(context,
                      'Không thể nhắn tin cho người này, 2 người đang không follow nhau');
                }
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.1,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1 , // Điều chỉnh kích thước tùy ý
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          maxRadius: 60,
                          backgroundImage: NetworkImage(userModel.avatarURL),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.02,
                            decoration: BoxDecoration(
                              color: snapshot.data?['isOnline'] ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),

                          ),
                        )
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userModel.fullName}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              chat.isNotEmpty
                                  ? idUserChat != idOther
                                      ? 'Bạn: $chat'
                                      : '$chat'
                                  : 'Hãy bắt đầu cuộc trò chuyện',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: idUserChat != idOther
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.sizeOf(context).height * 0.05,
                      child: Text(
                          lastActive,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
