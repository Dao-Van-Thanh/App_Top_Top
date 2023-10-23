import 'package:app/Services/call_video_service.dart';
import 'package:app/View/Widget/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../Provider/page_provider.dart';
import '../../../Provider/video_provider.dart';
import '../../Widget/video_player_item_edit.dart';

class ManHinhChinhSuaVideo extends StatefulWidget {
  final VideoProvider videoProvider;

  ManHinhChinhSuaVideo({required this.videoProvider});

  @override
  State<ManHinhChinhSuaVideo> createState() => _ManHinhChinhSuaVideoState();
}

class _ManHinhChinhSuaVideoState extends State<ManHinhChinhSuaVideo> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = widget.videoProvider.caption;
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
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
          child: Text('hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: TextField(
                      controller:_textEditingController ,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
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
                    padding: EdgeInsets.all(13),
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerItemEdit(widget.videoProvider.videoUrl),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  CallVideoService().updateVideoCaption(widget.videoProvider.videoId, _textEditingController.text);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_upward,color: Colors.white,),
                      Text('Lưu',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
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
