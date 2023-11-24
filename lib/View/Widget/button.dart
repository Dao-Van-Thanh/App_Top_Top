import 'package:flutter/material.dart';

class ButtonCusstom extends StatelessWidget {
  final String text;
  final IconData icon;

  final VoidCallback onPress;
  const ButtonCusstom({Key?key, required this.text, required this.icon, required this.onPress}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15.0), // Đặt giá trị padding là 10
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(300, 40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
          ),
        ),
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(width: 10,),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        )
    );
  }
}
