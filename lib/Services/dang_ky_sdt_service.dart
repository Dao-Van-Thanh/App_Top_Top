import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user_model.dart';

class DangKySdtService{

    Future<bool> KiemTraDangKySdt(UserCredential authResult,String phone) async {
      User? user = authResult.user;
      if (user != null) {
        // Đăng nhập thành công, kiểm tra xem người dùng đã đăng ký tài khoản hay chưa
        return await _checkIfUserIsRegistered(user.uid,phone);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user!.uid);
      return false;
    }

    Future<bool> _checkIfUserIsRegistered(String uid,String phone) async {
      // Kiểm tra xem người dùng có trong cơ sở dữ liệu Firestore hay không
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        return true; // Người dùng đã tồn tại
      } else {
        // Người dùng chưa tồn tại, hãy thêm họ vào cơ sở dữ liệu
        String idTopTop = await taoVaKiemTraIdTopTop();
        final realTime = FirebaseAuth.instance.currentUser?.metadata.creationTime;
        final userModel = UserModel(

          gender: 'None',
          email: 'None', // Thêm email nếu bạn muốn
          phone: '+84$phone', // Thêm số điện thoại nếu bạn muốn
          age: 'None', // Thêm tuổi nếu bạn muốn
          idTopTop: '@$idTopTop', // Thêm idTopTop nếu bạn muốn
          avatarURL: 'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=6&m=1223671392&s=170667a&w=0&h=zP3l7WJinOFaGb2i1F4g8IS2ylw0FlIaa6x3tP9sebU=', // Thêm URL ảnh đại diện nếu bạn muốn
          fullName: idTopTop, // Thêm tên đầy đủ nếu bạn muốn
          uid: uid, // Sử dụng uid từ người dùng Firebase
          birth: '01/01/1999', // Thêm ngày sinh nếu bạn muốn
          realTime:realTime.toString(),
          follower: [],
          following: [],
        );

        // Thêm người dùng vào cơ sở dữ liệu
        await FirebaseFirestore.instance.collection('Users').doc(uid).set(userModel.toJson());

        return false; // Trả về false vì người dùng chưa tồn tại
      }
    }

    String generate_idTopTop() {
      final random = Random();
      final _idTopTop = 'user${random.nextInt(90000) + 10000}';
      return _idTopTop;
    }

    Future<bool> _kiemTraIdTopTop(String _idTopTop) async {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('Users').
          where('idTopTop', isEqualTo: _idTopTop).get();
      return querySnapshot.docs.isEmpty;
    }

    Future<String> taoVaKiemTraIdTopTop() async {
      String _idTopTop = '';
      bool isUnique = false;

      while (!isUnique) {
        _idTopTop = generate_idTopTop();
        // Kiểm tra xem _idTopTop đã tồn tại trong bảng users hay chưa
        isUnique = await _kiemTraIdTopTop(_idTopTop);
      }
      return _idTopTop;
    }
}