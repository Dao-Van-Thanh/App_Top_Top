
import 'package:app/Provider/page_provider.dart';
import 'package:app/View/Pages/Chats/man_hinh_chat.dart';

import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Chats/man_hinh_hop_thu.dart';

import 'package:app/View/Pages/Profile/man_hinh_profile.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_quay_video.dart';
import 'package:app/View/Widget/custom_icon_add_video.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/edit_item_profile_provider.dart';
import '../Pages/TrangChu/trang_chu.dart';
import 'package:app/View/Pages/TrangChu/trang_chu.dart';
import 'package:app/View/Widget/custom_icon_add_video.dart';
import 'package:flutter/material.dart';

import '../Pages/QuayVideo/man_hinh_quay_video.dart';


class Bottom_Navigation_Bar extends StatefulWidget {
  const Bottom_Navigation_Bar({Key? key}) : super(key: key);

  @override
  State<Bottom_Navigation_Bar> createState() => _Bottom_Navigation_BarState();
}

class _Bottom_Navigation_BarState extends State<Bottom_Navigation_Bar> with WidgetsBindingObserver {
  int pageIdx = 0;
  List<Widget> pages = [
    Manhinhtrangchu(),
    Text('data'),
    ManHinhQuayVideo(),
    ManHinhHopThu(),
    ManHinhProfile(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //Sửa trạng thái người dùng đã online
    UserService.updateStatusUser({
      'lastActive':DateTime.now(),
      'isOnline':true
    });
  }

  // kiểm tra người dùng nếu offline
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        UserService.updateStatusUser({
          'lastActive':DateTime.now(),
          'isOnline':true
        });
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        UserService.updateStatusUser({
          'lastActive':DateTime.now(),
          'isOnline':false
        });
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ClipRect(
        child: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              pageProvider.setPage(idx);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 23, 1, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: pageProvider.page,
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
      body: pages[pageProvider.page],
    );
  }
}
