import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/dang_ky_email_provider.dart';
import '../../../Provider/dang_nhap_sdt_provider.dart';


class ManHinhQuenMatKhauEmail extends StatefulWidget {
  const ManHinhQuenMatKhauEmail({Key? key}) : super(key: key);

  @override
  State<ManHinhQuenMatKhauEmail> createState() => _ManHinhQuenMatKhauEmailState();
}

class _ManHinhQuenMatKhauEmailState extends State<ManHinhQuenMatKhauEmail> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DangKyEmailProvider>(context);
    final providerOTP = Provider.of<DangNhapSdtProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Đặt lại',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            provider.emailController.text='';
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
          right: 20
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quên Mật khẩu',
              style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
            ),
            Container(
              child: Text('Chúng tôi sẽ gửi mã đặt lại mật khẩu cho bạn qua email.',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: provider.emailController,
              onChanged: (text) {
                setState(() {
                  provider.updateButtonStatus(text.isNotEmpty);
                  provider.isClearButtonVisible = text.isNotEmpty;
                  if (provider.isButtonEnabled) {
                    provider.emailErrorText = null;
                  }
                  providerOTP.changeEmail(text);

                });
              },
              cursorColor: Colors.pinkAccent,
              decoration: InputDecoration(
                labelText: 'Địa chỉ email',
                labelStyle: const TextStyle(
                    color: Colors.grey
                ),
                errorText: provider.emailErrorText,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent), // Màu viền khi focus
                ),
                suffixIcon: provider.isClearButtonVisible
                    ? GestureDetector(
                  onTap: () {
                    provider.emailController.clear();
                    provider.isClearButtonVisible = false;
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.pinkAccent,
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: provider.isButtonEnabled
                    ? () {
                  setState(() {
                    provider.emailErrorText = provider.validateEmail()
                        ? null
                        : 'Nhập địa chỉ email hợp lệ';
                  });
                  if (provider.emailErrorText == null) {
                    providerOTP.sendPasswordResetEmail();
                    provider.emailController.text='';
                    Navigator.of(context).pop();
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: provider.isButtonEnabled
                      ? Colors.pinkAccent
                      : const Color.fromARGB(255, 219, 219, 219),
                  minimumSize: const Size(500, 50),
                ),
                child:  Text(
                  'Đặt lại',
                  style: TextStyle(
                    color: provider.isButtonEnabled ? Colors.white : Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
