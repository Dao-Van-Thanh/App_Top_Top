import 'dart:io';

import 'package:app/Services/user_service.dart';
import 'package:flutter/material.dart';

class ShowAvatar extends StatelessWidget {
  const ShowAvatar({super.key, required this.urlImage});
  final File urlImage;

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
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
                    child: Row(
                      children: [
                        textButton("Hủy",widthScreen,(){
                          Navigator.of(context).pop();
                        }),
                        textButton("Lưu",widthScreen,(){
                          UserService().uploadFile(urlImage);
                          Navigator.of(context).pop();
                        }),
                      ],
                    )
                  )


              ),

            ],
          ),
    );
  }
  textButton(String text,double width,VoidCallback onPress){

    return Container(
      width: width/2-80,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: text == "Hủy" ? Colors.white : Colors.redAccent,
        border: Border.all(color: text == "Hủy" ? Colors.black : Colors.transparent),
        borderRadius: BorderRadius.circular(10),
    ),
      child: TextButton(
        onPressed: onPress,
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
