import 'package:app/View/Pages/TrangChu/danh_cho_ban.dart';
import 'package:flutter/material.dart';

import 'dang_follow.dart';

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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: TabBar(
          indicator: BoxDecoration(),
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
            onPressed: () {},
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
