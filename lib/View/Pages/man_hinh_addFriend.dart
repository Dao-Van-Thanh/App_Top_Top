import 'package:app/Provider/follow_provider.dart';
import 'package:app/Services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                        child: UserCard(userData: userData[index]),
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

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  UserCard({required this.userData});

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context);
    return Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: userData['avatarURL'],
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['fullname'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: followProvider.isFollowed
                          ? [
                              Expanded(
                                child: _buttonFollowAndDelete(
                                    'Xóa',
                                    Colors.black,
                                    Colors.grey[300]!,
                                    userData['uid'],
                                    followProvider,
                                    150),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buttonFollowAndDelete(
                                    'Follow',
                                    Colors.white,
                                    Colors.red[400]!,
                                    userData['uid'],
                                    followProvider,
                                    150),
                              ),
                            ]
                          : [
                              Expanded(
                                child: _buttonFollowAndDelete(
                                    'Đang Follow',
                                    Colors.black,
                                    Colors.grey[300]!,
                                    userData['uid'],
                                    followProvider,
                                    300),
                              ),
                            ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buttonFollowAndDelete(String label, Color colorText, Color bg,
    String uid, FollowProvider followProvider, int size) {
  return ElevatedButton(
    onPressed: () {
      switch (label) {
        case 'Xóa':
          break;
        case 'Follow':
          UserService().followUser(uid);
          followProvider.isAcctionFollowed();
          break;
        case 'Đang Follow':
          UserService().unfollowUser(uid);
          followProvider.unFollow();
          break;
        default:
      }
    },
    style: ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(bg),
    ),
    child: Text(
      label.toString(),
      style: TextStyle(color: colorText),
    ),
  );
}
