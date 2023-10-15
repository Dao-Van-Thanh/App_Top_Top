import 'package:app/View/Pages/Profile/man_hinh_profile.dart';
import 'package:app/View/Pages/TrangChu/trang_chu.dart';
import 'package:app/View/Widget/custom_icon_add_video.dart';
import 'package:flutter/material.dart';

import '../Pages/QuayVideo/man_hinh_quay_video.dart';

class Bottom_Navigation_Bar extends StatefulWidget {
  const Bottom_Navigation_Bar({Key? key}) : super(key: key);

  @override
  State<Bottom_Navigation_Bar> createState() => _Bottom_Navigation_BarState();
}

class _Bottom_Navigation_BarState extends State<Bottom_Navigation_Bar> {
  int pageIdx = 0;

  List<Widget> pages = [
    Manhinhtrangchu(),
    Text('2'),
    ManHinhQuayVideo(),
    Text('4'),
    ManHinhProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: ClipRect(
        child: BottomNavigationBar(
              onTap: (idx) {
                setState(() {
                  pageIdx = idx;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromARGB(255, 23, 1, 1),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: pageIdx,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.home,
                      size: 30,
                  ),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.people,
                      size: 30,
                  ),
                  label: 'Bạn bè',
                ),
                BottomNavigationBarItem(
                  icon: CustomIconButtonAddVideo(),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.message,
                      size: 30,
                  ),
                  label: 'Hộp thư',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.person,
                      size: 30,
                  ),
                  label: 'Cá nhân',
                ),
              ],
            ),
          ),
      body: pages[pageIdx],
    );
  }
}