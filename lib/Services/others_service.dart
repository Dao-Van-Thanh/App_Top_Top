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
    try {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'following': FieldValue.arrayUnion([idOther])
      });

      await FirebaseFirestore.instance.collection('Users').doc(idOther).update({
        'follower': FieldValue.arrayUnion([user.uid])
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
    try {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'following': FieldValue.arrayRemove([idOther])
      });
      await FirebaseFirestore.instance.collection('Users').doc(idOther).update({
        'follower': FieldValue.arrayRemove([user.uid])
      });
    } catch (e) {
      print('Lỗi khi cập nhật trường following: $e');
    }
  }
}