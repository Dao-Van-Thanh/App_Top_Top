import 'package:flutter/material.dart';

import '../../Provider/follow_provider.dart';
import '../../Services/user_service.dart';

Widget buttonFollowAndDelete(String label, Color colorText, Color bg,
    String uid, FollowProvider followProvider, int size) {
  return ElevatedButton(
    onPressed: () {
      switch (label) {
        case 'Xóa':
          break;
        case 'Follow':
          UserService().followUser(uid);
          followProvider.isAcctionFollowed();
          break;
        case 'Đang Follow':
          UserService().unfollowUser(uid);
          followProvider.unFollow();
          break;
        default:
      }
    },
    style: ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(bg),
    ),
    child: Text(
      label.toString(),
      style: TextStyle(color: colorText),
    ),
  );
}