import 'package:app/Provider/video_provider.dart';
import 'package:app/Services/call_video_service.dart';
import 'package:flutter/material.dart';

class HomeSideBar extends StatelessWidget {
  final VideoProvider videoProvider;
  final CallVideoService callVideoService;

  const HomeSideBar(this.videoProvider, this.callVideoService, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CallVideoService callVideoService;
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 13, color: Colors.white);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _profileImageButton(),
            _sideBarItem('heart', videoProvider.countLike, style, 0,
                videoProvider.iconColors[0]),
            _sideBarItem('comment', videoProvider.countComment, style, 1,
                videoProvider.iconColors[1]),
            _sideBarItem('share', 1, style, 2, videoProvider.iconColors[2]),
          ],
        ),
      ),
    );
  }

  Widget _sideBarItem(
      String iconName, int label, TextStyle style, int index1, Color color) {
    IconData iconData;
    // Dựa vào tên iconName, bạn có thể map nó thành IconData tương ứng
    if (iconName == 'heart') {
      iconData = Icons.favorite;
    } else if (iconName == 'comment') {
      iconData = Icons.comment;
    } else if (iconName == 'share') {
      iconData = Icons.share;
    } else {
      // Icon mặc định hoặc xử lý các trường hợp khác
      iconData = Icons.star;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            switch (iconName) {
              case 'heart':
                videoProvider.incrementLike();
                callVideoService.likeVideo(videoProvider.videoId);
                break;
              case 'comment':
                // Xử lý cho mục 'comment'
                break;
              default:
            }
          },
          child: Icon(
            iconData,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label.toString(),
          style: style,
        ),
      ],
    );
  }

  Widget _profileImageButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: NetworkImage(videoProvider.profilePhoto),
              fit: BoxFit.cover,
            ),
          ),
          transform: Matrix4.translationValues(5, 0, 0),
        ),
        Positioned(
          bottom: -10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
            ),
            transform: Matrix4.translationValues(5, 0, 0),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}
