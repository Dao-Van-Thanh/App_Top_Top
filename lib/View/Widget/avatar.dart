import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle(
      {super.key,
      required this.urlImage,
      required this.widthImage,
      required this.heightImagel});

  final String urlImage;
  final double widthImage;
  final double heightImagel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightImagel,
      width: widthImage,
      child: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage:
            NetworkImage(urlImage),
          ),
    );
  }
}
