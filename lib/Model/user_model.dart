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
  String avatarURL;
  String uid;
  UserModel(
      {required this.gender,
      required this.email,
      required this.phone,
      required this.age,
      required this.avatarURL,
      required this.fullName,
      required this.uid,
      required this.birth,
      this.follower,
      this.following});

  Map<String, dynamic> toJson() => {
        "fullname": fullName,
        "email": email,
        "age": age,
        "uid": uid,
        "birth": birth,
        "avatarURL": avatarURL,
        "phone": phone,
        "follower": [],
        "following": [],
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshotData = snap.data() as Map<String, dynamic>;

    return UserModel(
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
      gender: '',
      uid: '',
    );
  }
}
