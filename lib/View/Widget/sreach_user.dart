import 'package:flutter/material.dart';

import '../../Services/search_service.dart';

class searchWidget extends StatefulWidget {
  searchWidget({Key? key}) : super(key: key);

  @override
  State<searchWidget> createState() => _searchWidgetState();
}

class _searchWidgetState extends State<searchWidget> {
  final controller = TextEditingController();
  List<String> username = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }
  Future<void> loadUser() async {
    final fetchedCaptions = await SearchService().getFollowingList();
    setState(() {
      username = fetchedCaptions;
    });
  }

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
              print(username);
              print(controller);

              
            },
            icon: const Icon(Icons.search),
          ),
           Expanded(
              child: TextField(
                maxLines: 1,
                controller: controller,
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
