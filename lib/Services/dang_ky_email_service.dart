import 'dart:math';

import 'package:app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DangKyEmailService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String createName(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex != -1 && atIndex < email.length - 1) {
      // Sử dụng phương thức substring để lấy phần sau ký tự '@'
      String domain = email.substring(0, atIndex);
      return '$domain';
    }
    return "";
  }

  // Phương thức để đăng ký người dùng bằng email và mật khẩu
  Future<String?> dangKyBangEmail(
      String email, String password, int age, String dayOfBirth) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel = UserModel(
        gender: 'nam',
        email: email,
        phone: '',
        age: age.toString(),
        uid: _auth.currentUser!.uid,
        avatarURL: 'https://firebasestorage.googleapis.com/v0/b/app-top-top.appspot.com/o/images%2Favatar_default.jfif?alt=media&token=5ddfd838-bfd6-456b-a15b-63721ddeb113&_gl=1*r8bhmr*_ga*NTIwNjEzMzU1LjE2OTU4NzAyOTk.*_ga_CW55HF8NVT*MTY5NzQyNDUzOC43MC4xLjE2OTc0Mjg4NjcuNTIuMC4w',
        follower: [],
        following: [],
        idTopTop: '@${createName(email)}',
        fullName: createName(email),
        birth: dayOfBirth,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth
              .currentUser!.uid) // Sử dụng UID của người dùng làm tên tài liệu
          .set(userModel.toJson())
          .catchError((error, StackTrace) {
        print(error);
      }); // Đăng ký thành công, trả về null để chỉ ra không có lỗi
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', userModel.uid);
    } catch (e) {
      return e.toString(); // Trả về thông báo lỗi nếu đăng ký thất bại
    }
  }


  // Phương thức để kiểm tra xem người dùng đã đăng nhập hay chưa
  bool daDangNhap() {
    return _auth.currentUser != null;
  }

  // Phương thức để đăng xuất người dùng
  void dangXuat() {
    _auth.signOut();
  }
}
