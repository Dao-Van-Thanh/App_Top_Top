import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Widget/button.dart';
import 'package:flutter/material.dart';

class ManHinhDangNhap extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 30,top: 50),
        child: Center(
          child: Column(
            children: [
              Texts("Đăng nhập TikTok",30,FontWeight.w800),
              SizedBox(height: 10),
              Texts("Quản lý tài khoản, kiếm tra thông báo, bình\n luận trên các video,v.v ", 18, FontWeight.normal),
              SizedBox(height: 40),
              ButtonCusstom(text: "Đăng nhập bằng số điện thoại", icon: Icons.phone, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Đăng nhập bằng email", icon: Icons.email, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Tiếp tục với Google", icon: Icons.g_mobiledata_sharp, onPress: (){}),
              SizedBox(height: 40),
              ButtonCusstom(text: "Tiếp tục với facebook", icon: Icons.facebook, onPress: (){}),
              SizedBox(height: 100),
              textButton("Bạn không có tài khoản?", 'Đăng ký', 18, FontWeight.bold,(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManHinhDangKy()),
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