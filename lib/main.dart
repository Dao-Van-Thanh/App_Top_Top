import 'package:app/Provider/dang_nhap_sdt_provider.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'package:app/View/Screen/DangNhap/man_hinh_dang_nhap_sdt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DangNhapSdtProvider()),
    ],child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManHinhDangKy(),
      // home: ManHinhDangNhapSDT(),
    );
  }
}
