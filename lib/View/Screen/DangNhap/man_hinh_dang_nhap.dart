import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Widget/button.dart';
import 'package:flutter/material.dart';

class ManHinhDangNhap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Texts("Đăng nhập TikTok", 30, FontWeight.w800),
              SizedBox(height: 10),
              Texts(
                  "Quản lý tài khoản, kiếm tra thông báo, bình\n luận trên các video,v.v ",
                  18,
                  FontWeight.normal),
              SizedBox(height: 40),
              ButtonCusstom(
                  text: "Đăng nhập bằng số điện thoại & Email",
                  icon: Icons.person,
                  onPress: () {}),
              SizedBox(height: 40),
              ButtonCusstom(
                  text: "Tiếp tục với Google",
                  icon: Icons.g_mobiledata_sharp,
                  onPress: () {}),
              SizedBox(height: 40),
              ButtonCusstom(
                  text: "Tiếp tục với facebook",
                  icon: Icons.facebook,
                  onPress: () {}),
              SizedBox(height: 100),
              textButton(
                  "Bạn không có tài khoản?", 'Đăng ký', 18, FontWeight.bold,
                  () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ManHinhDangKy(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0,
                          0.0); // Điểm bắt đầu (nếu bạn muốn chuyển từ bên phải)
                      const end = Offset
                          .zero; // Điểm kết thúc (nếu bạn muốn hiển thị ở giữa)
                      const curve = Curves
                          .easeInOut; // Loại chuyển cảnh (có thể tùy chỉnh)

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget Texts(String lable, double size, FontWeight fontWeight) {
    return Text(
      lable,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget textButton(String text, String buttonText, double size,
      FontWeight fontWeight, VoidCallback onPress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
          ),
        ),
        SizedBox(width: 5),
        TextButton(
          onPressed: onPress,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: size, fontWeight: fontWeight, color: Colors.red),
          ),
        )
      ],
    );
  }
}
