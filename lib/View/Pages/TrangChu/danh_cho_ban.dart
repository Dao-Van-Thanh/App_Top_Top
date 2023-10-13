import 'package:app/View/Pages/TrangChu/trang_chu.dart';
import 'package:flutter/material.dart';

import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';

class ForYou extends StatefulWidget {
  @override
  State<ForYou> createState() => _ForYou();
}

class _ForYou extends State<ForYou> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: PageView.builder(
          onPageChanged: (int page) {
            print("Page changed to $page");
          },
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  color: Colors.green,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        color: Colors.green,
                        child: VideoDetail(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.75,
                        color: Colors.green,
                        child: HomeSideBar(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}