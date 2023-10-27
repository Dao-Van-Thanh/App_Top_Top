import 'package:flutter/material.dart';

class searchWidget extends StatelessWidget {
  const searchWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(15),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5.0),

      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {// Handle emoji picker here.
            },
            icon: const Icon(Icons.search),
          ),
          const Expanded(
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm User',
                  border: InputBorder.none,
                ),
              ),
          ),
        ],
      ),
    );
  }
}
