import 'package:flutter/material.dart';

class AppItemMusic extends StatefulWidget {
  final String thumb;
  final String title;
  final bool? isForcus;
  const AppItemMusic({Key? key, required this.thumb, required this.title, required this.isForcus}) : super(key: key);

  @override
  State<AppItemMusic> createState() => _AppItemMusicState();
}

class _AppItemMusicState extends State<AppItemMusic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:widget.isForcus!?Colors.grey.withOpacity(0.3):Colors.white,
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
                  widget.thumb,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
