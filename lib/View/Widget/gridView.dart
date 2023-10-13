import 'package:app/Model/video_model.dart';
import 'package:flutter/material.dart';

class gridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //     ),
    //     padding: EdgeInsets.all(20),
    //     primary: false,
    //   itemCount: mock.url.length,
    //   itemBuilder:  (context,index) {
    //       final video = mock.url[index];
    //     return Container(
    //     width: 100,
    //     height: 100,
    //     padding: EdgeInsets.all(10),
    //     child: Stack(
    //       fit: StackFit.expand,
    //       alignment: Alignment.bottomRight,
    //       children: [
    //         Image(
    //           image: NetworkImage(video.urlImage.toString()),
    //           fit: BoxFit.cover,
    //         ),
    //         Positioned(
    //           bottom: 10,
    //           left: 0,
    //           child: Row(
    //             children: [
    //               SizedBox(width: 5),
    //               Icon(Icons.play_arrow,color: Colors.white),
    //               SizedBox(width: 5),
    //               Text("${video.views.toString()} ",style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 15
    //               ),
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //     );
    //   }
    //   );
    return Text('data');
  }

}
