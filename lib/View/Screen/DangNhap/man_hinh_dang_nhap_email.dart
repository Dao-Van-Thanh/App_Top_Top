import 'package:app/View/Screen/Profile/man_hinh_profile.dart';
import 'package:flutter/material.dart';

class ManHinhDangNhapEmail extends StatefulWidget {
  @override
  _ManHinhDangNhapEmail createState() => _ManHinhDangNhapEmail();

}

class _ManHinhDangNhapEmail extends State<ManHinhDangNhapEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;
  bool isForgotPasswordChecked = false;
  bool isSaveLogChecked = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      bool isEmailValid =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(emailController.text);
      bool isPasswordValid = passwordController.text.isNotEmpty;

      isButtonEnabled = isEmailValid && isPasswordValid;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: isSaveLogChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isSaveLogChecked = value ?? false;
                    });
                  },
                ),
                Text('Lưu thông tin đăng nhập'),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quên mật khẩu',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                // Xử lý đăng nhập ở đây
                String email = emailController.text;
                String password = passwordController.text;
                // Gọi hàm xử lý đăng nhập hoặc điều hướng đến màn hình chính
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ManHinhProfile()));
                // ...
              }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Color.fromARGB(
                          255, 210, 209, 209); // Màu xám khi không hợp lệ
                    }
                    return Colors.red; // Màu đỏ khi hợp lệ
                  },
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(350, 50), // Kích thước của nút
                ),
              ),
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
