import 'package:app/Provider/profile_provider.dart';
import 'package:flutter/material.dart';

import '../../Services/search_service.dart';

class searchWidget extends StatefulWidget {

  const searchWidget({Key? key, required this.profileProvider, required this.controller}) : super(key: key);

  final ProfileProvider profileProvider;
  final TextEditingController controller;

  @override
  State<searchWidget> createState() => _searchWidgetState();
}

class _searchWidgetState extends State<searchWidget> {
  List<String> username = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    widget.controller.addListener(_textFieldListener);
  }
  Future<void> loadUser() async {
    final fetchedCaptions = await SearchService().getFollowingList();
    setState(() {
      username = fetchedCaptions;
    });
  }
  void _textFieldListener() {
    widget.profileProvider.setSearch(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5.0),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {// Handle emoji picker here.

            },
            icon: const Icon(Icons.search),
          ),
           Expanded(
              child: TextField(
                maxLines: 1,

                controller: widget.controller,
                decoration: const InputDecoration(
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
