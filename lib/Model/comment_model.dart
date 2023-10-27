import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  String uid;
  String text;
  List likes;
  List recomments;
  Timestamp timestamp;

  CommentModel({
    required this.id,
    required this.uid,
    required this.text,
    required this.likes,
    required this.recomments,
    required this.timestamp,
  });

  factory CommentModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CommentModel(
      id: snapshot.id,
      uid: data['uid'] ?? '',
      text: data['text'] ?? '',
      likes: data['likes'] ?? [],
      recomments: data['recomments'] ?? [],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id' : id,
      'uid': uid,
      'text': text,
      'likes': likes,
      'recomments': recomments,
      'timestamp': timestamp,
    };
  }
}
