import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({Key? key}) : super(key: key);

  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Color heartIconColor = Colors.white;
  Color commentIconColor = Colors.white;
  Color bookmarkIconColor = Colors.white;
  Color shareIconColor = Colors.white;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _sideBarItem('heart', '100', style, heartIconColor),
            _sideBarItem('comment', '100', style, commentIconColor),
            _sideBarItem('bookmark', '', style, bookmarkIconColor),
            _sideBarItem('sharee', '', style, shareIconColor),
            AnimatedBuilder(
              animation: _animationController,
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: Image.asset('assets/cd.png'),
                  )
                ],
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: 2 * pi * _animationController.value,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sideBarItem(
      String iconName, String label, TextStyle style, Color iconColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (iconName == 'heart') {
            heartIconColor = Colors.red;
          } else if (iconName == 'comment') {
            commentIconColor = Colors.blue;
          } else if (iconName == 'bookmark') {
            bookmarkIconColor = Colors.yellow;
          } else if (iconName == 'share') {
            shareIconColor = Colors.green;
          }
        });
      },
      child: Column(
        children: [
          SvgPicture.asset('assets/$iconName.svg', color: iconColor),
          SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _profileImageButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(
                  "https://www.imgacademy.com/sites/default/files/ncsa-homepage-row-2022.jpg"),
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