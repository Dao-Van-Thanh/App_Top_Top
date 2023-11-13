import 'package:app/View/Widget/app_item_notify.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tất cả hoạt động',
          style: TextStyle(
            color: Colors.black,
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
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 100,
          itemExtent: 60,
          itemBuilder: (BuildContext context, int index){
            return const Column(
              children: [
                SizedBox(height: 10,),
                AppItemNotify(avatar: 'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/452f6d22389287.56312b2471813.png', nameUser: 'Thuy ngo', content: 'Đã follow bạn',),
              ],
            );
          }
      ),
    );
  }
}
