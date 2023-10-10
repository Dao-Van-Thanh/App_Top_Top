import 'package:app/View/Screen/DangNhap/man_hinh_dang_nhap.dart';
import 'package:app/View/Widget/button.dart';
import 'package:flutter/material.dart';

class ManHinhDangKy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 30,top: 50),
        child: Center(
          child: Column(
            children: [
              Texts("Đăng ký TikTok",30,FontWeight.w800),
              SizedBox(height: 10),
              Texts("Tạo hồ sơ, follow các tài khoản khác, quay\n video của chính bạn,v.v ", 18, FontWeight.normal),
              SizedBox(height: 40),
              ButtonCusstom(text: "Đăng ký bằng số điện thoại", icon: Icons.phone, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Đăng ký bằng email", icon: Icons.email, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Tiếp tục với Google", icon: Icons.g_mobiledata_sharp, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Tiếp tục với facebook", icon: Icons.facebook, onPress: (){}),
              SizedBox(height: 100),
              textButton("Bạn đã có tài khoản?", 'Đăng nhập', 18, FontWeight.bold,(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManHinhDangNhap()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  Widget Texts(String lable,double size,FontWeight fontWeight){
    return Text(
      lable,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    );
  }
  Widget textButton(String text,String buttonText,double size,FontWeight fontWeight,VoidCallback onPress){
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
          onPressed:  onPress,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: size,
                fontWeight: fontWeight,
                color: Colors.red
            ),
          ),
        )
      ],
    );
  }
}