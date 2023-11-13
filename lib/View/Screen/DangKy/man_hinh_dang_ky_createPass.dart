import 'package:app/Provider/gui_data_provider.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_date_of_birth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePassSingup extends StatefulWidget {
  const CreatePassSingup({Key? key, required TextEditingController data})
      : super(key: key);

  @override
  State<CreatePassSingup> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CreatePassSingup> {
  bool obscureText = true; // Thêm biến để theo dõi trạng thái ẩn/mở mật khẩu
  TextEditingController passWordController = TextEditingController();
  bool isButtonEnabled = false; // Trạng thái ban đầu của nút
  String? emailErrorText;
  bool isClearButtonVisible = false;

  bool _isPassValid(String text) {
    iconColors[0] =
        passWordController.text.length > 8 ? Colors.green : Colors.grey;
    iconColors[1] =
        containsDigit(passWordController.text) ? Colors.green : Colors.grey;
    if (iconColors[0] == Colors.green && iconColors[1] == Colors.green) {
      return true;
    }
    return false;
  }

  bool containsDigit(String text) {
    for (var i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        return true; // Có ít nhất một ký tự số
      }
    }
    return false; // Không có ký tự số nào
  }

  List<Color> iconColors = [Colors.grey, Colors.grey];
  @override
  Widget build(BuildContext context) {
    final myData = Provider.of<MyData>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Đăng ký',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Đặt căn chỉnh theo chiều ngang
          children: [
            const Text(
              'Tạo mật khẩu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passWordController,
              cursorColor: Colors.pinkAccent,
              onChanged: (text) {
                setState(() {
                  // Kiểm tra xem ô input có rỗng hay không để cập nhật trạng thái của nút
                  if (_isPassValid(text)) {
                    isButtonEnabled = true;
                  } else {
                    isButtonEnabled = false;
                  }
                });
              },
              obscureText:
                  obscureText, // Sử dụng biến để quản lý trạng thái ẩn/mở mật khẩu
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pinkAccent), // Màu viền khi focus
                ),
                labelText: 'Mật khẩu',
                labelStyle: const TextStyle(
                  color: Colors.grey
                ),
                // Các thuộc tính khác của InputDecoration
                suffixIcon: IconButton(
                  icon: Icon(
                    // Dựa vào trạng thái của obscureText để chọn biểu tượng mắt
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Khi người dùng nhấn vào biểu tượng mắt, thay đổi trạng thái của obscureText
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Mật khẩu của bạn phải gồm ít nhất:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: iconColors[0],
                  size: 20,
                ),
                const Text(
                  '8 ký tự (tối đa 20 ký tự)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: iconColors[1],
                  size: 20,
                ),
                const Text(
                  '1 chữ cái và 1 số)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      myData.updatePass(passWordController.text);
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateDateOfBirth()),
                        );
                      });
                    }
                  : null, // Vô hiệu hóa nút nếu ô input rỗng
              style: ElevatedButton.styleFrom(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Đường viền cong
                ),
                backgroundColor: isButtonEnabled
                    ? Colors.pinkAccent // Màu nền của nút khi có dữ liệu trong ô input
                    : const Color.fromARGB(
                        255, 219, 219, 219), // Màu nền của nút khi ô input rỗng
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
    );
  }
  // FUCK THUY
}
