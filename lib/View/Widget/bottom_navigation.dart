import 'package:app/Provider/page_provider.dart';
import 'package:app/Services/notifications_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Chats/man_hinh_hop_thu.dart';
import 'package:app/View/Pages/Profile/man_hinh_profile.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_quay_video.dart';
import 'package:app/View/Widget/custom_icon_add_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/TrangChu/trang_chu.dart';

class Bottom_Navigation_Bar extends StatefulWidget {
  const Bottom_Navigation_Bar({Key? key}) : super(key: key);

  @override
  State<Bottom_Navigation_Bar> createState() => _Bottom_Navigation_BarState();
}

class _Bottom_Navigation_BarState extends State<Bottom_Navigation_Bar>
    with WidgetsBindingObserver {
  int pageIdx = 0;
  List<Widget> pages = [
    const Manhinhtrangchu(),
    const Text('data'),
    const ManHinhQuayVideo(),
    const ManHinhHopThu(),
    const ManHinhProfile(),
  ];
  final notification = NotificationsService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notification.firebaseNotification(context);
    //Sửa trạng thái người dùng đã online
    if (user != null) {
      notification.getToken();
      UserService.updateStatusUser(
          {'lastActive': DateTime.now(), 'isOnline': true});
    }
    // updateAllUserAvatars();

    // CallVideoService().addStatusFieldToVideos();
  }

  // Future<void> updateAllUserAvatars() async {
  //   try {
  //     // Lấy tham chiếu đến bảng 'Users'
  //     final users = FirebaseFirestore.instance.collection('Videos');
  //
  //     // Lấy danh sách tất cả các tài liệu trong bảng 'Users'
  //     final querySnapshot = await users.get();
  //
  //     // Duyệt qua từng tài liệu và cập nhật trường 'avatarURL'
  //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //       // Lấy ID của tài liệu
  //       String userId = doc.id;
  //
  //       // Cập nhật trường 'avatarURL' với giá trị mới
  //       await users.doc(userId).update({
  //         'profilePhoto':
  //             'https://thumbs.dreamstime.com/b/default-avatar-profile-image-vector-social-media-user-icon-potrait-182347582.jpg',
  //       });
  //     }
  //
  //     print('Cập nhật thành công tất cả avatarURL trong bảng Users');
  //   } catch (e) {
  //     print('Lỗi: $e');
  //   }
  // }

  // kiểm tra người dùng nếu offline
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (user == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        UserService.updateStatusUser(
            {'lastActive': DateTime.now(), 'isOnline': true});
        break;
      case AppLifecycleState.hidden:
        UserService.updateStatusUser(
            {'lastActive': DateTime.now(), 'isOnline': false});
        break;
      case AppLifecycleState.inactive:
        UserService.updateStatusUser(
            {'lastActive': DateTime.now(), 'isOnline': false});
        break;
      case AppLifecycleState.paused:
        UserService.updateStatusUser(
            {'lastActive': DateTime.now(), 'isOnline': false});
        break;
      case AppLifecycleState.detached:
        UserService.updateStatusUser(
            {'lastActive': DateTime.now(), 'isOnline': false});
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
            pageProvider.setPage(idx);
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
