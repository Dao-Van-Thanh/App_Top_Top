import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String id; // ID của phòng chat
  List<Message> messages; // Danh sách tin nhắn
  List<String> uid; // Danh sách các ID của thành viên

  ChatModel({
    required this.id,
    required this.messages,
    required this.uid,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Phương thức factory để chuyển đổi dữ liệu JSON thành một đối tượng Chat
    final List<dynamic> messageList = json['messages'];
    final List<Message> messages =
    messageList.map((messageJson) => Message.fromJson(messageJson)).toList();

    final List<String> uid = List<String>.from(json['uid']);

    return ChatModel(
      id: json['id'],
      messages: messages,
      uid: uid,
    );
  }

  Map<String, dynamic> toJson() {
    // Phương thức để chuyển đối tượng Chat thành dữ liệu JSON
    return {
      'id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
      'uid': uid,
    };
  }
}

class Message {
  String chat; // Nội dung tin nhắn
  String idUserChat; // ID của người gửi
  DateTime timestamp; // Thời gian gửi tin nhắn

  Message({
    required this.chat,
    required this.idUserChat,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    Timestamp timestamp = json['timestamp'];
    // Phương thức factory để chuyển đổi dữ liệu JSON thành một đối tượng Message
    return Message(
      chat: json['chat'],
      idUserChat: json['idUserChat'],
      timestamp: timestamp.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    // Phương thức để chuyển đối tượng Message thành dữ liệu JSON
    return {
      'chat': chat,
      'idUserChat': idUserChat,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
