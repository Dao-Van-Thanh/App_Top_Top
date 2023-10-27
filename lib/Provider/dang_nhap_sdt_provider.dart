import 'package:app/Services/user_service.dart';
import 'package:app/View/Screen/DangNhap/man_hinh_dang_nhap_otp.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/notifications_service.dart';

class DangNhapSdtProvider extends ChangeNotifier {
  bool isPhoneNumberCheck = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isChecked = false;
  String phone = '';
  String error = '';
  bool isLoading = false;
  String verificationId = '';
  bool isCheckOtp = false;
  String smsCode = '';
  String message = '';

  void changeChecked(bool check) {
    isChecked = check;
    notifyListeners();
  }

  void setMessage(String s) {
    message = s;
    notifyListeners();
  }

  void setSmsCode(String s) {
    smsCode = s;
    notifyListeners();
  }

  void changCheckOTP(bool check) {
    isCheckOtp = check;
    notifyListeners();
  }

  void changePhone(String phone) {
    this.phone = phone;
    notifyListeners();
  }

  void changeLoading(bool loading) {
    this.isLoading = loading;
    notifyListeners();
  }

  void changePhoneNumberCheck(bool isPhoneNumberCheck) {
    this.isPhoneNumberCheck = isPhoneNumberCheck;
    notifyListeners();
  }

  Future<void> dangNhapPhone(BuildContext context) async {
    changeLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84$phone',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        setMessage('Lỗi thử lại');
        changePhoneNumberCheck(true);
        changeLoading(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        changeLoading(false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManHinhDangNhapOTP()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(BuildContext context, String otp) async {
    NotificationsService notifications = NotificationsService();
    try {
      changeLoading(true);
      User? existingUser = await FirebaseAuth.instance.currentUser;
        // Tạo một PhoneAuthCredential từ OTP và verificationId
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        );
        // Xác minh OTP và đăng nhập người dùng
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = await UserService().getUser(userCredential.user!.uid);
        if(user!= null){
          setMessage('Thành công');
          changCheckOTP(false);
          changeLoading(false);
          // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đây.
          await notifications.requestPermission();
          await notifications.getToken();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Bottom_Navigation_Bar(),
              ));
        }
        setMessage('Tài khoản không đúng, hãy thử lại!');
        changCheckOTP(true);
        changeLoading(false);
    } catch (e) {
      changeLoading(false);
      changCheckOTP(true);
      setMessage('Xác minh OTP thất bại');
    }
  }

  void guiLaiMaOTP(BuildContext context) {
    verifyOTP(context, smsCode);
  }
}
