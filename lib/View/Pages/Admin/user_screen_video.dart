import 'package:app/Provider/page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/gridView.dart';
import '../../Widget/grid_view_for_admin.dart';
import '../Profile/tab_video.dart';

class UserScreenVideo extends StatefulWidget {
  String uid;
  UserScreenVideo(this.uid);

  @override
  State<UserScreenVideo> createState() => _UserScreenVideoState();
}

class _UserScreenVideoState extends State<UserScreenVideo> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('UserScreenVideo'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Public'),
              Tab(text: 'Private'),
            ],
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridViewVideoForAdmin(widget.uid, 'videoPublic', pageProvider),
                GridViewVideoForAdmin(widget.uid, 'VideoPrivate', pageProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

