import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String uid;
  String idOther;
  String type;
  Timestamp timestamp;

  NotificationModel({
    required this.id,
    required this.uid,
    required this.idOther,
    required this.type,
    required this.timestamp,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel(
      id: snapshot.id,
      uid: data['uid'] ?? '',
      idOther: data['idOther'] ?? '',
      type: data['type'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id' : id,
      'uid': uid,
      'idOther': idOther,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
