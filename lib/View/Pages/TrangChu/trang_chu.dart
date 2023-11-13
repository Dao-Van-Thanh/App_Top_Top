import 'package:app/View/Pages/TrangChu/danh_cho_ban.dart';
import 'package:app/View/Pages/TrangChu/timkiem_trangchu.dart';
import 'package:flutter/material.dart';
import 'dang_follow.dart';

class Manhinhtrangchu extends StatefulWidget {
  const Manhinhtrangchu({super.key});

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
        leading: const SizedBox(),
        title: TabBar(
          indicator: const BoxDecoration(),
          controller: _tabController,
          tabs: const [
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
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManHinhTimKiem(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            ForYou(),
            Following(),
          ],
        ),
      ),
    );
  }
}
