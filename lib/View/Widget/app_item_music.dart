import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppItemMusic extends StatelessWidget {
  final String thumb;
  final String title;
  final bool? isForcus;
  AppItemMusic({Key? key, required this.thumb, required this.title, required this.isForcus}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color:isForcus!?Colors.grey.withOpacity(0.3):Colors.white,
      child: Row(
        children: [
          Container(
            width: 50, // Đặt kích thước của hình tròn
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all( // Thêm đường viền ngoài
                color: Colors.grey, // Màu của đường viền
                width: 1, // Độ dày của đường viền
              ),
              image: DecorationImage(
                image: NetworkImage(
                  thumb,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Đặt crossAxisAlignment thành CrossAxisAlignment.start
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
