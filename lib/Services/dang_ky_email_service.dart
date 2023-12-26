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
      return domain;
    }
    return "";
  }

  // Phương thức để đăng ký người dùng bằng email và mật khẩu
  Future<String?> dangKyBangEmail(
      String email, String password, int age, String dayOfBirth) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user == null) return 'Email không đúng';
      await result.user!.sendEmailVerification();
      final realTime = _auth.currentUser?.metadata.creationTime;
      UserModel userModel = UserModel(
        gender: 'nam',
        email: email,
        phone: '',
        age: age.toString(),
        uid: _auth.currentUser!.uid,
        avatarURL:
            'https://firebasestorage.googleapis.com/v0/b/app-top-top.appspot.com/o/images%2Favatar_default.jfif?alt=media&token=5ddfd838-bfd6-456b-a15b-63721ddeb113&_gl=1*r8bhmr*_ga*NTIwNjEzMzU1LjE2OTU4NzAyOTk.*_ga_CW55HF8NVT*MTY5NzQyNDUzOC43MC4xLjE2OTc0Mjg4NjcuNTIuMC4w',
        follower: [],
        following: [],
        realTime: realTime.toString(),
        idTopTop: '@${createName(email)}',
        fullName: createName(email),
        birth: dayOfBirth,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth
              .currentUser!.uid) // Sử dụng UID của người dùng làm tên tài liệu
          .set(
            userModel.toJson(),
          ); // Đăng ký thành công, trả về null để chỉ ra không có lỗi
    } catch (e) {
      return e.toString(); // Trả về thông báo lỗi nếu đăng ký thất bại
    }
    return null;
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
