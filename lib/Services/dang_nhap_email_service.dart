import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Model/user_model.dart';

class DangNhapEmailService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> dangNhapBangEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Đăng nhập thành công
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('Users').doc(user.uid).get();
        if (userSnapshot.exists) {
          // Chuyển dữ liệu từ DocumentSnapshot sang UserModel
          UserModel userModel = UserModel.fromSnap(userSnapshot);
          // In thông tin UserModel
          debugPrint('Thông tin UserModel:');
          debugPrint('Full Name: ${userModel.fullName}');
          debugPrint('Age: ${userModel.age}');
          debugPrint(userModel.uid);

          return true;
        } else {
          debugPrint('Không tìm thấy thông tin người dùng trong Firestore.');
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      if (e.code == 'user-not-found') {
        debugPrint('Email không tồn tại.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Sai mật khẩu.');
      } else {
        debugPrint('Lỗi đăng nhập: ${e.code}');
      }
      return false;
    }
  }
}
