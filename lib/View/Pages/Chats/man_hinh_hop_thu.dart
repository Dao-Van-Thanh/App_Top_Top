import 'package:app/Model/chat_model.dart';
import 'package:app/Model/notifycation_model.dart';
import 'package:app/Model/user_model.dart';
import 'package:app/Services/chat_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Chats/man_hinh_chat.dart';
import 'package:app/View/Pages/notification/notificationScreen.dart';
import 'package:app/View/Widget/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Services/notifications_service.dart';


class ManHinhHopThu extends StatefulWidget {
  const ManHinhHopThu({super.key});

  @override
  State<ManHinhHopThu> createState() => _ManHinhHopThuState();
}

class _ManHinhHopThuState extends State<ManHinhHopThu> {
  ChatService service = ChatService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: NotificationsService().getNotification(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Text('No data available');
              }
              List<NotificationModel> notificationList = [];
              snapshot.data?.docs.forEach((doc) {
                NotificationModel notifiModel = NotificationModel.fromSnapshot(doc);
                notificationList.add(notifiModel);
              });
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationScreen(notificationList: notificationList,)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  height: 50,
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              child: Center(
                                child: Icon(Icons.notifications, color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Những thông báo mới', style: TextStyle(color: Colors.black)),
                            ],

                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.navigate_next, color: Colors.black, size: 24),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(

            child: StreamBuilder<List<ChatModel>>(
                stream: service.getChatsByUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                        String? timestamp = '' ;
                        try {
                          chat =
                              ls?[index].messages[ls[index].messages.length - 1].chat;
                          idUserChat = ls?[index]
                              .messages[ls[index].messages.length - 1]
                              .idUserChat;
                          timestamp = ls?[index].messages[ls[index].messages.length - 1].timestamp.toString();
                        } catch (e) {
                          chat = '';
                          idUserChat = '';
                          timestamp = '' ;
                        }
                        return _itemGroupChat(
                            context, ls![index], chat ?? '', idUserChat!, uid!,timestamp!);
                        // return Text('data');
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    ));
  }

  Widget _itemGroupChat(BuildContext context, ChatModel model, String chat,
      String idUserChat, String uid, String timestampme) {
    String idOther = service.getIdOtherInListUID(model.uid);
    UserService userService = UserService();
    String time = '';
    try{
      time = UserService.formattedTimeAgo(DateTime.parse(timestampme));
    }catch(e){

      time = '';
    }
    return StreamBuilder<DocumentSnapshot>(
        stream: userService.getUser(idOther),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('${snapshot.error} ======================');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserModel userModel = UserModel.fromSnap(snapshot.data!);
            bool checkFollow = userModel.following!.contains(uid) &&
                userModel.follower!.contains(uid);
            Timestamp timestamp = snapshot.data!['lastActive'];
            String lastActive =
                UserService.formattedTimeAgo(timestamp.toDate());
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
                      width: MediaQuery.of(context).size.width *
                          0.13, // Điều chỉnh kích thước tùy ý
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          maxRadius: MediaQuery.of(context).size.width * 0.06,
                          // maxRadius: MediaQuery.of(context).size.width * 0.05,
                          backgroundImage: NetworkImage(userModel.avatarURL),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.006
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.02,
                            decoration: BoxDecoration(
                              color: snapshot.data?['isOnline']
                                  ? Colors.green
                                  : Colors.grey,
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
                            userModel.fullName,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                                      : chat
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
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.sizeOf(context).height * 0.05,
                      child: snapshot.data!['isOnline']
                          ? const SizedBox()
                          : Flexible(
                              child: Text(
                                lastActive,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                textAlign: TextAlign.end,
                              ),
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
