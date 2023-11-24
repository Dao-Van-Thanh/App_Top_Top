import 'package:app/View/Widget/gridView.dart';
import 'package:flutter/material.dart';

import '../../../Provider/page_provider.dart';

class TabBookMark extends StatelessWidget {
  String uid;
  String label;
  PageProvider pageProvider;
  TabBookMark(this.uid,this.label,this.pageProvider, {super.key});
  @override
  Widget build(BuildContext context) {
    return GridViewVideo(uid,label,pageProvider);
  }
}
