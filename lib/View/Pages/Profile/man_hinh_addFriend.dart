import 'package:app/Provider/follow_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/user_card.dart';

class AddFriend extends StatefulWidget {
  AddFriend({Key? key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  bool _hasInitialized = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Thêm bạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: UserService().getListFriend(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            cursorColor: Colors.pinkAccent,
                            decoration: const InputDecoration(
                              hintText: 'Tìm kiếm theo tên',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                            onTap: () {},
                            onChanged: (text) {},
                          )),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final followProvider = ChangeNotifierProvider.value(
                        value: FollowProvider(),
                        child: UserCard(userData: userData[index],heightImage: 80,widthImage: 80,checkScreen: true),
                      );
                      return followProvider;
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}




