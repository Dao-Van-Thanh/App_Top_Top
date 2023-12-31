import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  double size;
  String? text;
  IconData? icon;
  bool? isIcon;
  final Color color;
  final Color backgroundColor;
  final Color boderColor;

  AppButtons({Key? key,this.isIcon = false,this.text,this.icon,required this.size, required this.color, required this.backgroundColor, required this.boderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          border: Border.all(
              color: boderColor,
              width: 1.0
          ),
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor
      ),
      child:
      Center(child: Icon(icon,color: color.withOpacity(0.8),)),
    ),
        Text(text.toString(),style: const TextStyle(fontSize: 15,color: Colors.grey),),
      ]
    );
  }
}
