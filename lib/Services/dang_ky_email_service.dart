import 'dart:math';

import 'package:app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  List<String> avatar = [
    'https://p16-sign-useast2a.tiktokcdn.com/tos-useast2a-avt-0068-giso/9cc5a254434a03a37c75210074d89283~c5_100x100.jpeg?x-expires=1697288400&x-signature=aOhSjWIcG16OWmbXstJp3BkEZA0%3D',
    'https://p16-sign-useast2a.tiktokcdn.com/tos-useast2a-avt-0068-euttp/0ac5c928977816a378bfc327d9ad3ec2~c5_100x100.jpeg?x-expires=1697288400&x-signature=mDJURQ1IDTtoDbVjpfZCluq8CNc%3D',
    'https://p16-sign-va.tiktokcdn.com/tos-maliva-avt-0068/596238a62dbb46d8bc958060e86324b7~c5_100x100.jpeg?x-expires=1697288400&x-signature=M21bzOy5N1daZsdhovvHMj2MOF4%3D'
  ];

  String getRandomAvatar() {
    final random = Random();
    final randomIndex = random.nextInt(avatar.length);
    return avatar[randomIndex];
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
        avatarURL: getRandomAvatar(),
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
