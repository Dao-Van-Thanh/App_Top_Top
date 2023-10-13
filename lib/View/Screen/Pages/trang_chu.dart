import 'package:flutter/material.dart';

import '../../Widget/home_side_bar.dart';
import '../../Widget/video_detail.dart';

class Manhinhtrangchu extends StatefulWidget {
  @override
  State<Manhinhtrangchu> createState() => _ManhinhtrangchuState();
}

class _ManhinhtrangchuState extends State<Manhinhtrangchu> {
  bool _isFollowingSelected = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       GestureDetector(
      //         onTap: () => {
      //           setState(() {
      //             _isFollowingSelected = true;
      //           })
      //         },
      //         child: Text('Following',
      //             style: Theme.of(context).textTheme.bodyText1!.copyWith(
      //                 fontSize: _isFollowingSelected ? 16 : 14,
      //                 color:
      //                     _isFollowingSelected ? Colors.white : Colors.grey)),
      //       ),
      //       Text(
      //         "  |  ",
      //         style: Theme.of(context)
      //             .textTheme
      //             .bodyText1!
      //             .copyWith(fontSize: 14, color: Colors.grey),
      //       ),
      //       GestureDetector(
      //         onTap: () => {
      //           setState(() {
      //             _isFollowingSelected = false;
      //           })
      //         },
      //         child: Text("For You",
      //             style: Theme.of(context).textTheme.bodyText1!.copyWith(
      //                 fontSize: !_isFollowingSelected ? 16 : 14,
      //                 color:
      //                     !_isFollowingSelected ? Colors.white : Colors.grey)),
      //       )
      //     ],
      //   ),
      // ),
      body:SafeArea(
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
                color: Colors.purple,
              ), // Container
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      color: Colors.purple,
                      child: VideoDetail(),
                    ), // Container
                  ), // Expanded
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.75,
                      color: Colors.purple,
                      child: HomeSideBar(),
                    ), // Container
                  ), // Expanded
                ], // children
              ), // Row
            ], // children
          ); // Stack
        }, // itemBuilder
      ),
      ),// body
    );
  }
}
