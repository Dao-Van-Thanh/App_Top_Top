import 'package:app/Services/user_service.dart';
import 'package:app/View/Widget/app_item_notify.dart';
import 'package:flutter/material.dart';

import '../../../Model/notifycation_model.dart';
import '../../../Model/user_model.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationModel> notificationList;
  const NotificationScreen({Key? key, required this.notificationList})
      : super(key: key);

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
      body: ListView.separated(
          itemCount: widget.notificationList.length,
          itemBuilder: (BuildContext context, int index) {
            NotificationModel notificationModel =
                widget.notificationList[index];
            return FutureBuilder<UserModel?>(
              future: UserService().getDataUser(notificationModel.idOther),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final useData = snapshot.data!;
                return AppItemNotify(
                  avatar: useData.avatarURL,
                  nameUser: useData.fullName,
                  content: 'Đã ${notificationModel.type}',
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox()),
    );
  }
}
