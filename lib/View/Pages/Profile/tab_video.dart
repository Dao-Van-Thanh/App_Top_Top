import 'package:app/Provider/page_provider.dart';
import 'package:app/View/Widget/gridView.dart';
import 'package:flutter/material.dart';

class TabVideo extends StatelessWidget {
  String uid;
  PageProvider pageProvider;
  TabVideo(this.uid, this.pageProvider);

  @override
  Widget build(BuildContext context) {
    return GridViewVideo(uid,pageProvider);
  }
}
