import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_createPass.dart';
import 'package:flutter/material.dart';

class ManHinhDangKyEmail extends StatefulWidget {
  const ManHinhDangKyEmail({Key? key}) : super(key: key);

  @override
  State<ManHinhDangKyEmail> createState() => _MyManHinhDangKyEmailState();
}

class _MyManHinhDangKyEmailState extends State<ManHinhDangKyEmail> {
  TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false; // Trạng thái ban đầu của nút
  String? emailErrorText;
  bool isClearButtonVisible = false; // trạng thái ban đầu của nút x
  bool _isEmailValid(String text) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                onChanged: (text) {
                  setState(() {
                    // Kiểm tra xem ô input có rỗng hay không để cập nhật trạng thái của nút
                    isButtonEnabled = text.isNotEmpty;
                    isClearButtonVisible = text.isNotEmpty;
                    if (isButtonEnabled) {
                      emailErrorText = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Địa chỉ email',
                  errorText: emailErrorText,
                  suffixIcon: isClearButtonVisible
                      ? GestureDetector(
                          onTap: () {
                            // Xoá toàn bộ nội dung trong TextField khi nút "X" được nhấn
                            emailController.clear();
                            // Ẩn nút "X" sau khi xoá
                            isClearButtonVisible = false;
                          },
                          child: Icon(Icons.close), // Icon "X"
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        setState(() {
                          emailErrorText = _isEmailValid(emailController.text)
                              ? null
                              : 'Nhập địa chỉ email hợp lệ';
                        });
                        if (emailErrorText != null ||
                            emailErrorText !=
                                'Nhập địa chỉ email hợp lệ') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePassSingup()),
                          );
                        }
                      }
                    : null, // Vô hiệu hóa nút nếu ô input rỗng
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // Đường viền cong
                  ),
                  backgroundColor: isButtonEnabled
                      ? Colors
                          .red // Màu nền của nút khi có dữ liệu trong ô input
                      : const Color.fromARGB(255, 219, 219,
                          219), // Màu nền của nút khi ô input rỗng
                  minimumSize: const Size(500, 50), // Kích thước nút
                ),
                child: const Text(
                  'Tiếp',
                  style: TextStyle(
                    color: Colors.white, // Màu chữ
                    fontSize: 18.0, // Kích thước chữ
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
