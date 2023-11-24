import 'package:flutter/material.dart';

class SnackBarWidget{
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Thời gian hiển thị của Snackbar
      ),
    );
  }
}