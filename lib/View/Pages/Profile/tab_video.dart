import 'package:app/View/Widget/gridView.dart';
import 'package:flutter/material.dart';

class TabVideo extends StatelessWidget {
  String uid;
  TabVideo(this.uid);

  @override
  Widget build(BuildContext context) {
    return GridViewVideo(uid);
  }
}
