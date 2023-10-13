import 'package:app/View/Widget/home_side_bar.dart';
import 'package:app/View/Widget/video_detail.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isFollowingSelected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFollowingSelected = true;
                });
              },
              child: Text('Following',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: _isFollowingSelected ? 18 : 14,
                      color:
                          _isFollowingSelected ? Colors.white : Colors.grey)),
            ),
            Text(
              ' | ',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 14, color: Colors.grey),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFollowingSelected = false;
                });
              },
              child: Text('For you',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: !_isFollowingSelected ? 18 : 14,
                      color:
                          !_isFollowingSelected ? Colors.white : Colors.grey)),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: PageView.builder(
        onPageChanged: (int page) {
          print('Page changed to $page');
          // Xử lý sự kiện khi người dùng thay đổi trang ở đây
        },
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                color: Colors.grey,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment
                    .center, // Đặt giá trị này thành MainAxisAlignment.center
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green,
                      height: MediaQuery.of(context).size.height / 4,
                      child: VideoDetail(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      height: MediaQuery.of(context).size.height / 1.75,
                      child: HomeSideBar(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
