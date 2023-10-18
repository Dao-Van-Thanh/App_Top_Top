import 'dart:async';

import 'package:app/Model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> addMessageToChat(String chatId, String chat, String idUserChat) async {
    try {
      final chatRef = _firestore.collection('Chats').doc(chatId);
      // Thêm tin nhắn vào danh sách messages trong phòng chat
      await chatRef.update({
        'messages': FieldValue.arrayUnion([
          {
            'chat': chat,
            'idUserChat': idUserChat,
            'timestamp': DateTime.now(),
          }
        ]),
      });
    } catch (e) {
      print('Lỗi khi thêm tin nhắn: $e');
    }
  }

  //lấy ra tất cả phòng chat của id user
  Stream<List<ChatModel>> getChatsByUserId() {
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



}
