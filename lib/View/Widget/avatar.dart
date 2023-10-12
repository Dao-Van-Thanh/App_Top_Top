import 'package:cached_network_image/cached_network_image.dart';
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
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: urlImage,
        fit: BoxFit.cover,
        height: heightImagel,
        width: widthImage,
      ),
    );
  }
}
