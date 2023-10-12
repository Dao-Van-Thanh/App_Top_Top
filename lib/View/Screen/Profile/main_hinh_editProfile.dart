import 'package:app/Provider/edit_item_profile_provider.dart';
import 'package:app/Provider/edit_profile_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Screen/Profile/man_hinh_edit_item_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editItemProvider = Provider.of<EditItemProfileProvider>(context);
    final editProfileProvider = Provider.of<EditProfileProvider>(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: UserService().getDataUser('lxCeVjiVu3YeZcgjZJ3fN8TAGBG2'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Sửa hồ sơ',
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
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Sửa hồ sơ',
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
            ),
            body: const Center(
              child: Text('Không có dữ liệu'),
            ),
          );
        } else {
          final userData = snapshot.data!;
          editProfileProvider.setfullname = userData['fullname'];
          editProfileProvider.setidTopTop = userData['idTopTop'];
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Sửa hồ sơ',
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            // Hình ảnh
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://cdn.pixabay.com/photo/2016/11/14/04/36/boy-1822614_640.jpg',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            // Biểu tượng
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Giới thiệu về bạn',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _inkWellRowEdit(
                        'Tên', editProfileProvider.getfullname.toString(), () {
                      editItemProvider.updateProfileData(
                          'Tên', editProfileProvider.getfullname.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditItemProfile()),
                      );
                    }),
                    _inkWellRowEdit(
                        'TikTok ID', editProfileProvider.getidTopTop.toString(),
                        () {
                      editItemProvider.updateProfileData('TikTok ID',
                          editProfileProvider.getidTopTop.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditItemProfile()),
                      );
                    }),
                    _inkWellRowEdit('Tiểu sử', 'fuck thuy', () {
                      editItemProvider.updateProfileData(
                          'Tiểu sử', 'fuck thuy');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditItemProfile()),
                      );
                    }),
                    _inkWellRowEdit('Số điện thoại', userData['phone'], () {
                      _showDialog(context);
                    }),
                    _inkWellRowEdit('Email', userData['email'], () {
                      _showDialog(context);
                    }),
                    _inkWellRowEdit('Ngày sinh', userData['birth'], () {
                      _showDialog(context);
                    }),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _showDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Hiện tại tính năng đang được cập nhật.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _inkWellRowEdit(String label, String value, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 23,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
