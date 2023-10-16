import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user_model.dart';

class DangNhapEmailService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> DangNhapBangEmail(String email, String password) async {
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
          print('Thông tin UserModel:');
          print('Full Name: ${userModel.fullName}');
          print('Age: ${userModel.age}');
          print('${userModel.uid}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', userModel.uid);
          return true;
        } else {
          print('Không tìm thấy thông tin người dùng trong Firestore.');
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('Email không tồn tại.');
      } else if (e.code == 'wrong-password') {
        print('Sai mật khẩu.');
      } else {
        print('Lỗi đăng nhập: ${e.code}');
      }
      return false;
    }
  }
}
