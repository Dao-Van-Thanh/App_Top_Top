import 'dart:io';

import 'package:flutter/material.dart';

class ShowAvatar extends StatelessWidget {
  const ShowAvatar({super.key, required this.urlImage});
  final File urlImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [

                  Image.file(urlImage),
              Positioned(
                  bottom: 0,
                  child: TextButton(
                    onPressed: (){},
                    child: Text("Hủy"),
                  )


              ),

            ],
          ),
    );
  }
  textButton(String text){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: text == "Hủy" ? Colors.white : Colors.transparent)
      ),
      child: TextButton(
        onPressed: (){},
        child: Text(
          text,
          style: TextStyle(
            color: text == "Hủy" ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
