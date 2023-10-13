import 'package:app/View/Pages/TrangChu/dang_follow.dart';
import 'package:app/View/Pages/TrangChu/danh_cho_ban.dart';
import 'package:flutter/material.dart';

class Manhinhtrangchu extends StatefulWidget {
  @override
  State<Manhinhtrangchu> createState() => _ManhinhtrangchuState();
}

class _ManhinhtrangchuState extends State<Manhinhtrangchu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Dành cho bạn',
            ),
            Tab(
              text: 'Đang Follow',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

              // Hành động khi nhấn vào biểu tượng tìm kiếm
              // Có thể điều hướng đến màn hình tìm kiếm hoặc thực hiện hành động tìm kiếm ở đây
            },
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            ForYou(),
            Following(),
          ],
        ),
      ),
    );
  }
}