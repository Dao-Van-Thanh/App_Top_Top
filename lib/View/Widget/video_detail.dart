import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({super.key});

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "@nguyenvandat",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        ExpandableText(
            'Hom nay toi buon Hom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buonHom nay toi buon',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w100),
            expandText: 'Đọc thêm')
      ],
    );
  }
}
