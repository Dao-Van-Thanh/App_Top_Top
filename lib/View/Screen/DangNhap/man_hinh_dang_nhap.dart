import 'package:flutter/material.dart';
import 'package:app/Provider/dang_nhap_google_provider.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Screen/DangNhap/man_hinh_dang_nhap_email_voi_sdt.dart';
import 'package:app/View/Widget/button.dart';
import 'package:app/Services/dang_nhap_facebook_service.dart';
import 'package:app/View/Widget/bottom_navigation.dart';

class ManHinhDangNhap extends StatelessWidget {
  final DangNhapGooogleProvider dangnhapGGprovider = DangNhapGooogleProvider();

  Future<void> _signInWithFacebook(BuildContext context) async {
    final authService = DangNhapFacebookService();
    final userCredential = await authService.signInWithFacebook(context);

    if (userCredential != null) {
      // Xử lý khi đăng nhập thành công (nếu cần)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottom_Navigation_Bar()),
      );
    } else {
      // Xử lý khi đăng nhập thất bại
      print('Dang nhap that bai');

    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    await dangnhapGGprovider.signInWithGoogle(); // Gọi hàm đăng nhập với Google từ AuthProvider

    if (dangnhapGGprovider.user != null) {
      // Xử lý khi đăng nhập thành công (nếu cần)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottom_Navigation_Bar()),
      );
    } else {
      // Xử lý khi đăng nhập thất bại
      print('Dang nhap that bai');
    }
  }

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
                "Quản lý tài khoản, kiểm tra thông báo, bình\n luận trên các video,v.v ",
                18,
                FontWeight.normal,
              ),
              SizedBox(height: 40),
              ButtonCusstom(
                text: "Đăng nhập bằng số điện thoại & Email",
                icon: Icons.person,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManHinhDangNhapEmailVoiSdt(),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              ButtonCusstom(
                text: "Tiếp tục với Google",
                icon: Icons.g_mobiledata_sharp,
                onPress: () async {
                  await _signInWithGoogle(context); // Gọi hàm đăng nhập với Google
                },
              ),
              SizedBox(height: 40),
              ButtonCusstom(
                text: "Tiếp tục với Facebook",
                icon: Icons.facebook,
                onPress: () async {
                  await _signInWithFacebook(context);
                },
              ),
              textButton(
                "Bạn không có tài khoản?",
                'Đăng ký',
                18,
                FontWeight.bold,
                    () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ManHinhDangKy(),
                      transitionsBuilder: (context, animation,
                          secondaryAnimation, child) {
                        const begin =
                        Offset(1.0, 0.0); // Điểm bắt đầu (nếu bạn muốn chuyển từ bên phải)
                        const end = Offset.zero; // Điểm kết thúc (nếu bạn muốn hiển thị ở giữa)
                        const curve =
                            Curves.easeInOut; // Loại chuyển cảnh (có thể tùy chỉnh)

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
                },
              ),
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
              fontSize: size,
              fontWeight: fontWeight,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
