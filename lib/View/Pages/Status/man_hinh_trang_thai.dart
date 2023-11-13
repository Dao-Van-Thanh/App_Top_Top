import 'package:app/Model/user_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:app/View/Pages/Profile/man_hinh_addFriend.dart';
import 'package:app/View/Pages/Status/follower.dart';
import 'package:app/View/Pages/Status/following.dart';
import 'package:app/View/Pages/Status/friendScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManHinhTrangThai extends StatefulWidget {
  const ManHinhTrangThai({super.key,required this.following,required this.follower, required this.uid, required this.initTab});

  final List<String> following;
  final List<String> follower;
  final String uid;
  final int initTab;
  // final String id;
  // final List<String> following;
  // final List<String> ngfollow;




  @override
  State<ManHinhTrangThai> createState() => _ManHinhTrangThaiState();
}

class _ManHinhTrangThaiState extends State<ManHinhTrangThai> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4,vsync: this);
    _tabController.animateTo(widget.initTab); // Chuyển đến tab ban đầu
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserService().getUser(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          UserModel userModel = UserModel.fromSnap(snapshot.data!);
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: appBar(userModel.fullName,context),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.black,
                      indicatorPadding: const EdgeInsets.only(left: 10,right: 10),
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      controller: _tabController,
                      tabs: [
                        Tab(child: Text("Đang follow ${widget.following.length}",style: const TextStyle(fontSize: 20))),
                        Tab(child: Text("Follower ${widget.follower.length}",style: const TextStyle(fontSize: 20))),
                        const Tab(child: Text("Bạn bè",style: TextStyle(fontSize: 20))),
                        const Tab(child: Text("Được đề xuất",style: TextStyle(fontSize: 20))),
                      ],
                      // tabs: tabs,
                    )
                ),
              ),
              body: Container(
                margin: const EdgeInsets.only(left: 10,right: 10),
                child: TabBarView(
                  controller: _tabController,
                  children: [

                    FollowingScreen(uId: widget.uid,following: widget.following),
                    FollowerScreen(uId: widget.uid,follower: widget.follower,),
                    const FriendScreen(),
                    Container(color: Colors.yellow),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  appBar(String username,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(
                CupertinoIcons.back,
                size: 40,
                color: Colors.black
            ),
          ),
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 20)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFriend()));
            },
            child: Image.asset(
              'assets/adduser.png',
              width: 30,
              height: 30,
            ),
          )
        ],
      ),
    );
  }
}
