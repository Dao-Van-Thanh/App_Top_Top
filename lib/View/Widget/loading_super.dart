import 'package:flutter/material.dart';

class LoadingSuperWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingSuperWidget({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hiển thị child khi isLoading là false
        if (!isLoading) child,

        // Hiển thị tiện ích tải khi isLoading là true
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
