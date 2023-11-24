import 'package:app/Services/user_service.dart';
import 'package:app/View/Widget/app_item_notify.dart';
import 'package:flutter/material.dart';

import '../../../Model/notifycation_model.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationModel> notificationList ;
  NotificationScreen({Key? key, required this.notificationList}) : super(key: key);

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
          itemCount: widget.notificationList.length,
          itemExtent: 60,
          itemBuilder: (BuildContext context, int index){
            NotificationModel notificationModel = widget.notificationList[index];
            print(notificationModel.type);
            return FutureBuilder<Map<String, dynamic>?>(
              future: UserService().getDataUser(notificationModel.idOther),
              builder:(context, snapshot) {
                final useData = snapshot.data!;
                return  Column(
                  children: [
                    SizedBox(height: 10,),
                    AppItemNotify(avatar: useData['avatarURL'], nameUser: useData['fullname'], content: 'Đã ${notificationModel.type}',),
                  ],
                );
              },

            );
          }
      ),
    );
  }
}
