import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  LoadingWidget({required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.0), // Màu đen với độ trong suốt 50%
          )
        ),
        const Center(
          child: SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow
                  ],       /// Optional, The color collections
                  strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                  pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
              ),
          )
        )
      ],
    )
        : SizedBox.shrink(); // Nếu không isLoading, trả về widget trống
  }
}
