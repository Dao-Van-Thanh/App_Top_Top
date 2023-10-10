import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/dang_nhap_sdt_provider.dart';
import 'View/Screen/DangKy/man_hinh_dang_ky.dart';

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
    );
  }
}
