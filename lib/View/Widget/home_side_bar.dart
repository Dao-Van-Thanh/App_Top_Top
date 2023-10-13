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

  @override
  void initState() {
    // TODO: implement initState
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
        .bodyLarge!
        .copyWith(fontSize: 13, color: Colors.white);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _profileImageButton(),
            _sideBarItem('heart', '100', style),
            _sideBarItem('comment', '100', style),
            _sideBarItem('bookmark', '', style),
            AnimatedBuilder(
                animation: _animationController,
                child: Stack(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      color: Colors.amber,
                      child: Image.asset('assets/cd.png'),
                    )
                  ],
                ),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: 2 * pi * _animationController.value,
                    child: child,
                  );
                })
          ],
        ),
      ),
    );
  }

  _sideBarItem(String iconName, String label, TextStyle style) {
    return Column(
      children: [
        SvgPicture.asset('assets/$iconName.svg'),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: style,
        )
      ],
    );
  }

  _profileImageButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.imgacademy.com/sites/default/files/ncsa-homepage-row-2022.jpg"),
              )),
        ),
        Positioned(
            bottom: -10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ))
      ],
    );
  }
}
