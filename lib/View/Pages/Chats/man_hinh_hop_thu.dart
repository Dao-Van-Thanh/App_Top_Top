import 'package:app/Model/chat_model.dart';
import 'package:app/Model/user_model.dart';
import 'package:app/Services/chat_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Chats/man_hinh_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          stream: service.getChatsByUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('${snapshot.error} ======================');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<ChatModel>? ls = snapshot.data;
              return ListView.builder(
                itemCount: ls?.length,
                itemBuilder: (context, index) {
                  String? chat;
                  try{
                    chat = ls?[index].messages[ls[index].messages.length - 1].chat;
                  }catch(e){
                    chat = '';
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ManHinhChat(ls[index].id),)
                      );
                    },
                    child: _itemGroupChat(context, ls![index],chat??''),
                  );
                  // return Text('data');
                },
              );
            }
          }),
    ));
  }

  Widget _itemGroupChat(BuildContext context, ChatModel model,String chat) {
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
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.1,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 60, // Điều chỉnh kích thước tùy ý
                    height: 100, // Điều chỉnh kích thước tùy ý
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      maxRadius: 60,
                      backgroundImage: NetworkImage(userModel.avatarURL),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userModel.fullName}',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$chat',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        });
  }
}
