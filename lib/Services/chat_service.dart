import 'dart:io';
import 'package:app/Model/chat_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notifications_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Stream<ChatModel?> getChatDataStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .snapshots()
        .map((chatSnapshot) {
      try {
        if (chatSnapshot.exists) {
          return ChatModel.fromJson(chatSnapshot.data()!, chatSnapshot.id);

        } else {
          return null;
        }
      } catch (e) {
        print('===========$e');
      }
    });
  }
  List<String> getIdOther(List<Message> ls) {
    if(user != null){
      return ls
          .where((message) => message.idUserChat != user!.uid)
          .map((message) => message.idUserChat)
          .toList();
    }
    return [];
  }
  Future<DocumentSnapshot> getUser(String documenId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documenId)
          .get();
      return snapshot;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }
  Future<bool> addMessageToChat(String chatId, String chat, String idUserChat) async {
    try {
      final chatRef = _firestore.collection('Chats').doc(chatId);
      // Thêm tin nhắn vào danh sách messages trong phòng chat
      String idChat = _firestore.collection('Chats').doc().id;
      print(idChat);
      await chatRef.update({
        'messages': FieldValue.arrayUnion([
          {
            'idChat': idChat,
            'chat': chat,
            'idUserChat': idUserChat,
            'timestamp': DateTime.now(),
          }
        ]),
      });
      return true;
    } catch (e) {
      print('Lỗi khi thêm tin nhắn: $e');
      return false;
    }
  }

  //lấy ra tất cả phòng chat của id user
  Stream<List<ChatModel>> getChatsByUser() {
    return FirebaseFirestore.instance
        .collection('Chats')
        .where('uid', arrayContains: user!.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((chatDocument) {
        return ChatModel.fromJson(chatDocument.data(),chatDocument.id);
      }).toList();
    });
  }
  String getIdOtherInListUID(List<String> ls){
    for(var i in ls){
      if(!i.contains(user!.uid)){
        return i;
      }
    }
    return '';
  }

  Future<void> deleteMessageByChatId(String chatId, String idChatToDelete) async {
    final chatRef = FirebaseFirestore.instance.collection('Chats').doc(chatId);
    chatRef.get().then((chatDocument) {
      final messages = chatDocument.data()?['messages'] as List<dynamic>;

      final updatedMessages = messages.where((message) {
        return message['idChat'] != idChatToDelete;
      }).toList();

      chatRef.update({'messages': updatedMessages});
    });
  }

  Future uploadFileToChat({required File file,required String idPhongChat}) async{
    UserService userService = UserService();
    try{
      String imageUrl = await userService.uploadFileToStorege(file);
      final check = await addMessageToChat(idPhongChat, imageUrl, user!.uid);
      if(check){
        return true;
      }return false;
    }catch(e){
      print('$e =========== Lỗi up load ảnh ở màn hình chat');
      return false;
    }
  }
}
