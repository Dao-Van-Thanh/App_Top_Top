import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String gender;
  String fullName;
  String email;
  String age;
  String birth;
  String phone;
  List<String>? following;
  List<String>? follower;
  List<String>? saveVideos;
  String avatarURL;
  String uid;
  String idTopTop;

  UserModel(
      {required this.gender,
      required this.email,
      required this.phone,
      required this.age,
      required this.idTopTop,
      required this.avatarURL,
      required this.fullName,
      required this.uid,
      required this.birth,
      this.follower,
      this.following,
      this.saveVideos});

  Map<String, dynamic> toJson() => {
        "fullname": fullName,
        "email": email,
        "age": age,
        "uid": uid,
        "idTopTop": idTopTop,
        "birth": birth,
        "avatarURL": avatarURL,
        "phone": phone,
        "follower": [],
        "following": [],
        "saveVideos": [],
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshotData = snap.data() as Map<String, dynamic>;
    return UserModel(
      idTopTop: snapshotData['idTopTop'] ?? '',
      fullName: snapshotData['fullname'] ?? '',
      email: snapshotData['email'] ?? '',
      age: snapshotData['age'] ?? '',
      avatarURL: snapshotData['avatarURL'] ?? '',
      phone: snapshotData['phone'] ?? '',
      birth: snapshotData['birth'] ?? '',
      follower: (snapshotData['follower'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      following: (snapshotData['following'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      saveVideos: (snapshotData['saveVideos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      gender: snapshotData['gender'] ?? 'None',
      uid: snapshotData['uid'] ?? '',
    );
  }
}
