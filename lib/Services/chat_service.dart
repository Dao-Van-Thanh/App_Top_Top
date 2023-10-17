import 'package:app/Model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<ChatModel?> getChatDataStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .snapshots()
        .map((chatSnapshot) {
      try {
        if (chatSnapshot.exists) {
          final chatData = chatSnapshot.data() as Map<String, dynamic>;
          final List<dynamic> messageList = chatData['messages'];
          final List<Message> messages = messageList
              .map((messageJson) => Message.fromJson(messageJson as Map<String, dynamic>))
              .toList();

          final List<String> uid = List<String>.from(chatData['uid']);
          return ChatModel(
            id: chatSnapshot.id,
            messages: messages,
            uid: uid,
          );

        } else {
          return null;
        }
      } catch (e) {
        print('===========$e');
      }
    });
  }
  List<String> getIdOther(List<Message> ls) {
    final user = FirebaseAuth.instance.currentUser;
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
}
