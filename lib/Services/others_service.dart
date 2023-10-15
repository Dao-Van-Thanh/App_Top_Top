import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/user_model.dart';

class OthersService{
  static Stream<DocumentSnapshot> getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    return userRef.snapshots();
  }
  void FollowOther(String idOther) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    try {
      await userRef.update({
        'following': FieldValue.arrayUnion([idOther])
      });
    } catch (e) {
      print('Lỗi khi cập nhật trường following: $e');
    }
  }
  void UnFollowOther(String idOther) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    try {
      await userRef.update({
        'following': FieldValue.arrayRemove([idOther])
      });
    } catch (e) {
      print('Lỗi khi cập nhật trường following: $e');
    }
  }
}