import 'package:app/Services/dang_nhap_email_service.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
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
              cursorColor: Colors.pinkAccent,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent), // Màu viền khi focus
                ),
                labelStyle: TextStyle(
                    color: Colors.grey
                ),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              cursorColor: Colors.pinkAccent,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent), // Màu viền khi focus
                ),
                labelStyle: TextStyle(
                    color: Colors.grey
                ),
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
              margin: EdgeInsets.only(left: 15),
              child: const Text(
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
                  ? () async {
                // Xử lý đăng nhập ở đây
                String email = emailController.text;
                String password = passwordController.text;
                DangNhapEmailService service = DangNhapEmailService();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: <Widget>[
                        CircularProgressIndicator(), // Biểu tượng nạp
                        SizedBox(width: 16.0), // Khoảng cách giữa biểu tượng và văn bản
                        Text('Đang tải...'), // Văn bản
                      ],
                    ),
                    duration: Duration(seconds: 3), // Độ dài hiển thị
                  ),
                );
                bool check = await service.DangNhapBangEmail(email, password);
                if(check){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => const Bottom_Navigation_Bar(),));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tài khoản không chính xác!'),
                    ),
                  );
                }

              }
                 : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return const Color.fromARGB(
                          255, 210, 209, 209); // Màu xám khi không hợp lệ
                    }
                    return Colors.pinkAccent; // Màu đỏ khi hợp lệ
                  },
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(350, 50), // Kích thước của nút
                ),
              ),
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
