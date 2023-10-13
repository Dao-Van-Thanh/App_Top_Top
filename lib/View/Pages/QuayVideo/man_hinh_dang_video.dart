import 'package:app/Provider/quay_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManHinhDangVideo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<QuayVideoProvider>(
        builder: (context, provider, _) {
          return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                      'Đăng',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            width: 1
                          )
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              // color: Colors.blue,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: const TextField(
                                textAlignVertical: TextAlignVertical.top, // Đặt con trỏ ở đầu tiên ở góc trái trên cùng
                                decoration: InputDecoration(
                                  hintText: 'Viết nội dung video của bạn ở đây',
                                  border: InputBorder.none, // Bỏ viền dưới chân
                                  contentPadding: EdgeInsets.all(10), // Khoảng cách bên trong TextField
                                ),
                                maxLines: null, // Cho phép người dùng nhập nhiều dòng
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              color: Colors.red,
                              padding: EdgeInsets.all(13),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(16),
                                ),

                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              )
          );
        },
    );
  }
}