import 'package:app/Provider/quay_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManHinhDangVideo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<QuayVideoProvider>(
        builder: (context, provider, _) {
          return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                ),
              )
          );
        },
    );
  }
}