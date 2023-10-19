import 'package:app/Model/user_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManHinhTrangThai extends StatelessWidget {
  ManHinhTrangThai({super.key, required this.username});

  final String username;

  final List<Tab> tabs = [
    Tab(child: Text("Đang follow",style: TextStyle(color: Colors.black,fontSize: 20))),
    Tab(child: Text("Follower",style: TextStyle(color: Colors.black,fontSize: 20))),
    Tab(child: Text("Bạn bè",style: TextStyle(color: Colors.black,fontSize: 20))),
    Tab(child: Text("Được đề xuất",style: TextStyle(color: Colors.black,fontSize: 20))),
  ];
  final List<Widget> tabsContent=[
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    Container(color: Colors.yellow),
  ];
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print("==============================================");
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService().getUser(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          UserModel userModel = UserModel.fromSnap(snapshot.data!);
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: appBar(userModel.fullName),
                centerTitle: true,

                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      tabs: tabs,
                    )
                ),
              ),
              body: TabBarView(
                children: tabsContent,
              ),
            ),
          );
        }
      },
    );
  }
  appBar(String username) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(CupertinoIcons.back, size: 40,color: Colors.black),
          Text(username, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 20)),
          Image.asset(
            'assets/adduser.png',
            width: 30,
            height: 30,
          )
        ],
      ),
    );
  }

  tabBar(){
    return PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: TabBar(
          indicatorColor: Colors.white,
          tabs: tabs,
        )
    );
  }
}
