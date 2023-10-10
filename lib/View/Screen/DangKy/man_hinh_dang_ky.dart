import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_email.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_sdt.dart';
import 'package:flutter/material.dart';

class ManHinhDangKy extends StatefulWidget {
  @override
  State<ManHinhDangKy> createState() => _ManHinhDangKyState();
}

class _ManHinhDangKyState extends State<ManHinhDangKy>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Đăng ký',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
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
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Điện thoại',
              ),
              Tab(
                text: 'Email',
              ),
            ],
            labelColor: Colors.black,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.black, // Màu sắc của underline
                width: 2.0, // Độ dày của underline
              ),
              insets: EdgeInsets.symmetric(horizontal: 100.0),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [ManHinhDangKySDT(), ManHinhDangKyEmail()],
        ),
      ),
    );
  }
}
