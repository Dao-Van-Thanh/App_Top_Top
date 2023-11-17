import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/follow_provider.dart';
import 'bottom_follow_delete.dart';

class UserCard extends StatelessWidget {
  final bool checkScreen;
  final double heightImage;
  final double widthImage;
  final Map<String, dynamic> userData;


  const UserCard({super.key, required this.userData, required this.heightImage, required this.widthImage, required this.checkScreen});

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context);
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: userData['avatarURL'],
                fit: BoxFit.cover,
                height: heightImage,
                width: widthImage,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userData['fullname'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  checkScreen ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: followProvider.isFollowed
                        ? [
                      Expanded(
                        child: buttonFollowAndDelete(
                            'Xóa',
                            Colors.black,
                            Colors.grey[300]!,
                            userData['uid'],
                            followProvider,
                            150),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buttonFollowAndDelete(
                            'Follow',
                            Colors.white,
                            Colors.red[400]!,
                            userData['uid'],
                            followProvider,
                            150),
                      ),
                    ]
                        : [
                      Expanded(
                        child: buttonFollowAndDelete(
                            'Đang Follow',
                            Colors.black,
                            Colors.grey[300]!,
                            userData['uid'],
                            followProvider,
                            300),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: followProvider.isFollowed?[
                      SizedBox(
                        width: 150, // Đặt chiều rộng của Container
                        height: 40,
                        child: buttonFollowAndDelete(
                            'Follow',
                            Colors.white,
                            Colors.red[400]!,
                            userData['uid'],
                            followProvider,
                            150),
                      )
                    ]:[
                      SizedBox(
                        width: 150, // Đặt chiều rộng của Container
                        height: 40,
                        child:  buttonFollowAndDelete(
                            'Đang Follow',
                            Colors.black,
                            Colors.grey[300]!,
                            userData['uid'],
                            followProvider,
                            300),
                      )
                    ]
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}