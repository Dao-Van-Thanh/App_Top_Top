import 'package:flutter/material.dart';

class text extends StatelessWidget {
  const text({Key?key, required this.lable, required this.size, required this.fontWeight}):super(key: key);
  final String lable;
  final double size;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      lable,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
