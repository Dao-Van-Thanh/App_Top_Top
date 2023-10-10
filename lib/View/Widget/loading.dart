import 'package:flutter/material.dart';

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
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ],
    )
        : SizedBox.shrink(); // Nếu không isLoading, trả về widget trống
  }
}
