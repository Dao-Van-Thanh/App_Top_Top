import 'package:app/Provider/video_provider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class VideoDetail extends StatefulWidget {
  final VideoProvider videoProvider;
  const VideoDetail(this.videoProvider, {Key? key}) : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Align(
        alignment: Alignment.centerLeft, // Đặt căn chỉnh về phía trái
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Đặt căn chỉnh về phía trái
          children: [
            Text(
              widget.videoProvider.username,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            ExpandableText(
              widget.videoProvider.caption,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
              expandText: 'Đọc thêm',
              collapseText: 'Thu gọn',
              linkEllipsis: true,
              linkColor: Colors.white60,
              linkStyle: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
