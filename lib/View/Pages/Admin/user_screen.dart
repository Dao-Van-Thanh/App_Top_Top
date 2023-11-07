import 'dart:ui';

import 'package:app/Model/user_model.dart';
import 'package:app/Services/tab_video_service.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Profile/main_hinh_editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserService().getUser(uid),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center();
        }
        UserModel userModel = UserModel.fromSnap(snapshot.data!);

        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text("${userModel.fullName}",
                    style: TextStyle(color: Colors.black))),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userModel.avatarURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                       Center(
                         child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Độ mờ
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                userModel.avatarURL,
                              ),
                              maxRadius: 100,
                            ),
                          ),
                      ),
                       ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text("Đã hoạt động được: ${FirebaseAuth.instance.currentUser?.metadata.creationTime}"),
              SizedBox(height: 50),
              textButton("Thông tin cá nhân", context,(){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              }),
              SizedBox(height: 50),
              textButton("Thay đổi mật khẩu", context,(){

              }),
              SizedBox(height: 50),
              FutureBuilder(
                future: TabVideoService.getVideosByUid(uid),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center();
                  }
                  // VideoModel videoModel = VideoModel.fromSnap(snapshot.data!)
                  return textButton("${snapshot.data!.length} Videos", context,(){
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget textButton(String title,BuildContext context,VoidCallback onPress){
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
        ),
        onPressed: onPress,
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(color: Colors.black,fontSize: 18)),
              Icon(Icons.navigate_next,color: Colors.black)
            ],
          ),
        ));
  }
}
