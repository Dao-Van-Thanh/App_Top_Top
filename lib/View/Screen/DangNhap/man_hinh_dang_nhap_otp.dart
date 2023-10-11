import 'package:app/Provider/dang_nhap_sdt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../Widget/loading.dart';

class ManHinhDangNhapOTP extends StatefulWidget {
  @override
  _ManHinhDangNhapOTPState createState() => _ManHinhDangNhapOTPState();
}

class _ManHinhDangNhapOTPState extends State<ManHinhDangNhapOTP> {
  int _secondsRemaining = 60; // Số giây còn lại
  late Timer _timer; // Đối tượng Timer để đếm ngược
  bool _isCodeSubmitted = true;

  @override
  void initState() {
    super.initState();
    startTimer(); // Bắt đầu đếm ngược khi màn hình được tạo
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            timer.cancel(); // Hủy Timer khi thời gian kết thúc
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy Timer khi màn hình bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<DangNhapSdtProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Container(
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Để quay lại màn hình trước đó
                      },
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nhập mã gồm 6 chữ số',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Mã của bạn đã được gửi đến +84${provider.phone}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        OtpTextField(
                          numberOfFields: 6,
                          borderColor: Color(0xFF512DA8),
                          cursorColor: Colors.pinkAccent,
                          enabled: _isCodeSubmitted,
                          focusedBorderColor: Colors.pinkAccent,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          autoFocus: true,
                          onCodeChanged: (String code) {
                            // Xử lý sự kiện khi người dùng thay đổi mã
                          },
                          onSubmit: (String verificationCode) {
                            setState(() {
                              _isCodeSubmitted = false;
                              provider.setSmsCode(verificationCode);
                              provider.verifyOTP(context,verificationCode);
                              _isCodeSubmitted = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        provider.isCheckOtp
                            ? Text(
                                '${provider.message}',
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _secondsRemaining > 0
                                  ? null
                                  : () {
                                      setState(() {
                                        _isCodeSubmitted = true;
                                        _secondsRemaining = 60;
                                        startTimer();
                                        provider.guiLaiMaOTP(context);
                                      });
                                    },
                              child: Text(
                                'Gửi lại mã',
                                style: TextStyle(
                                    color: _secondsRemaining > 0
                                        ? Colors.grey
                                        : Colors.pinkAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$_secondsRemaining s',
                              style: TextStyle(
                                  color: _secondsRemaining > 0
                                      ? Colors.grey
                                      : Colors.grey,
                                  // Thay đổi màu sắc khi hết thời gian
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            LoadingWidget(isLoading: provider.isLoading),
          ],
        );
      },
    );
  }
}
