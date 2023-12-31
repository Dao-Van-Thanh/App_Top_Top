import 'package:flutter/material.dart';

class AppItemNotify extends StatelessWidget {
  final String avatar;
  final String nameUser;
  final String content;
  const AppItemNotify(
      {Key? key,
      required this.avatar,
      required this.nameUser,
      required this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => NotificationScreen()),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: MediaQuery.of(context).size.width * 0.06,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape
                          .circle, // Đặt hình dạng của container thành hình tròn
                      border: Border.all(
                        // Thêm đường viền ngoài
                        color: Colors.grey, // Màu của đường viền
                        width: 2, // Độ dày của đường viền
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          avatar,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nameUser, style: const TextStyle(color: Colors.black)),
                    Text(content,
                        style: TextStyle(color: Colors.black.withOpacity(0.4))),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            const Icon(Icons.navigate_next, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}
