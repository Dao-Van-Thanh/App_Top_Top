import 'package:app/View/Screen/DangNhap/man_hinh_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DangNhapSdtProvider extends ChangeNotifier{
  bool isPhoneNumberCheck= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isChecked = false;
  String phone = '';
  String error = '';
  bool isLoading = false;
  String verificationId = '';
  bool isCheckOtp = false;

  void changeChecked(bool check){
    isChecked = check;
    notifyListeners();
  }


  void changCheckOTP(bool check){
    isCheckOtp = check;
    notifyListeners();
  }

  void changePhone(String phone){
    this.phone = phone;
    notifyListeners();
  }

  void changeLoading(bool loading){
    this.isLoading = loading;
    notifyListeners();
  }

  void changePhoneNumberCheck(bool isPhoneNumberCheck){
    this.isPhoneNumberCheck = isPhoneNumberCheck;
    notifyListeners();
  }

  Future<void> dangNhapPhone(BuildContext context) async {
    changeLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84$phone',
      verificationCompleted: (PhoneAuthCredential credential) { },
      verificationFailed: (FirebaseAuthException e) {
        changePhoneNumberCheck(true);
        changeLoading(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        changeLoading(false);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => ManHinhOTP())
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(BuildContext context,String otp) async {
    try {
      changeLoading(true);
      // Tạo một PhoneAuthCredential từ OTP và verificationId
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      // Xác minh OTP và đăng nhập người dùng
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('thành công');
      changCheckOTP(false);
      changeLoading(false);
      // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đây.
    } catch (e) {
      changeLoading(false);
      changCheckOTP(true);
      print('Xác minh OTP thất bại: $e');
    }
  }
}