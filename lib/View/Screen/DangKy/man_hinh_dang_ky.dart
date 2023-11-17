import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_email_voi_sdt.dart';
import 'package:app/View/Screen/DangNhap/man_hinh_dang_nhap.dart';
import 'package:app/View/Widget/button.dart';
import 'package:flutter/material.dart';

class ManHinhDangKy extends StatelessWidget {
  const ManHinhDangKy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              texts("Đăng ký TikTok", 30, FontWeight.w800),
              const SizedBox(height: 10),
              texts(
                  "Tạo hồ sơ, follow các tài khoản khác, quay\n video của chính bạn,v.v ",
                  18,

                  FontWeight.normal),
              const SizedBox(height: 40),
              ButtonCusstom(
                  text: "Đăng ký bằng số điện thoại & Email",
                  icon: Icons.person,
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder:
                            (context) => const ManHinhDangKyEmailWithSDT(),)
                    );
                  }),
              const SizedBox(height: 40),
              ButtonCusstom(
                  text: "Tiếp tục với Google",
                  icon: Icons.g_mobiledata_sharp,
                  onPress: () {}),
              const SizedBox(height: 40),
              ButtonCusstom(
                  text: "Tiếp tục với facebook",
                  icon: Icons.facebook,
                  onPress: () {}),
              const SizedBox(height: 100),
              textButton(
                  "Bạn đã có tài khoản?", 'Đăng nhập', 18, FontWeight.bold, () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ManHinhDangNhap(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0,
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

  Widget texts(String lable, double size, FontWeight fontWeight) {
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
        const SizedBox(width: 5),
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
