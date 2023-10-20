import 'package:flutter/material.dart';

import '../../../Services/comment_service.dart';


class NotifiDelete extends StatelessWidget {
  const NotifiDelete({super.key, required this.videoId, required this.cmtId});

  final String videoId;
  final String cmtId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Bạn có chắc chắn muốn \n xóa comment ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey),
                  TextButton(
                      onPressed: () {
                        CommentService().deleteCmt(videoId, cmtId);
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                          child: Text('Xóa',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)))),
                  const Divider(color: Colors.grey),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                          child: Text('Hủy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey)))),
                ],
              ),
            ),
          ),
        ]);
  }
}