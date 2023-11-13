import 'package:app/Services/call_video_service.dart';
import 'package:flutter/material.dart';

import '../../../Provider/video_provider.dart';
import '../../Widget/video_player_item_edit.dart';

class ManHinhChinhSuaVideo extends StatefulWidget {
  final VideoProvider videoProvider;

  const ManHinhChinhSuaVideo({super.key, required this.videoProvider});

  @override
  State<ManHinhChinhSuaVideo> createState() => _ManHinhChinhSuaVideoState(videoProvider.blockComments);
}

class _ManHinhChinhSuaVideoState extends State<ManHinhChinhSuaVideo> {
  bool checked;
  _ManHinhChinhSuaVideoState(this.checked);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = widget.videoProvider.caption;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Chỉnh sửa bài đăng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: TextButton(
          child: const Text('hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: TextField(
                      controller: textEditingController,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Viết nội dung video của bạn ở đây',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    padding: const EdgeInsets.all(13),
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child:
                            VideoPlayerItemEdit(widget.videoProvider.videoUrl),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  const Icon(
                    Icons.comment_bank_outlined,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'Cho phép bình luận ',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const Spacer(),
                  Switch(
                    value: !checked,
                    onChanged: (value) {
                      setState(() {
                        checked = !checked;
                      });
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  CallVideoService().updateVideoCaption(
                      widget.videoProvider.videoId,
                      textEditingController.text,
                      checked);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      Text(
                        'Lưu',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
