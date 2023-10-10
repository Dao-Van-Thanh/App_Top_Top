import 'package:flutter/material.dart';

class ButtonCusstom extends StatelessWidget {
  const ButtonCusstom({Key?key, required this.text, required this.icon, required this.onPress}):super(key: key);
  final String text;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(15.0), // Đặt giá trị padding là 10
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            Size(300, 40), // Đặt kích thước theo chiều rộng và chiều cao mong muốn
          ),
        ),
        onPressed: (){
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        )
    );
  }
}
