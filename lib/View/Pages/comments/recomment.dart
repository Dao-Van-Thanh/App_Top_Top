import 'package:app/Services/comment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Model/comment_model.dart';
import '../../../Model/user_model.dart';
import '../../../Services/user_service.dart';

class ReComment extends StatelessWidget {
  String idVideo;
  String idComment;

  ReComment(this.idVideo, this.idComment);

  @override
  Widget build(BuildContext context) {
    CommentService commentService = CommentService();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back), // Mũi tên quay lại
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Trả lời',
          style: TextStyle(color: Colors.black),
        ), // Tiêu đề của AppBar
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.close), // Nút đóng
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: commentService.getCommentById(idVideo, idComment),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            CommentModel commentModel = CommentModel.fromSnapshot(
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
            String time =
                UserService.formattedTimeAgo(commentModel.timestamp.toDate());
            bool isLiked = commentModel.likes.contains(uid);

            return StreamBuilder<DocumentSnapshot>(
              stream: UserService().getUser(commentModel.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // Hiển thị tiêu đề tải dữ liệu
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                UserModel? userModel = UserModel.fromSnap(
                    snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.14,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                maxRadius: MediaQuery.sizeOf(context).height * 0.03,
                                backgroundImage: NetworkImage(userModel.avatarURL),
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${userModel.idTopTop}' + ' • ' + '$time',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: MediaQuery.sizeOf(context).height * 0.017
                                          ),
                                      ),
                                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
                                      Text(
                                        '${commentModel.text}',
                                        style: TextStyle(
                                          color: Colors.black,
                                            fontSize: MediaQuery.sizeOf(context).height * 0.02
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextButton.icon(
                                              onPressed: () => {
                                                commentService.likeComment(
                                                    idVideo, idComment, isLiked)
                                              },
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isLiked ? Colors.red : Colors.grey,
                                              ),
                                              label: Text(
                                                  '${commentModel.likes.length}',
                                                  style: TextStyle(
                                                    color: Colors.grey
                                                  ),
                                              ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: UserService().getUser(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              UserModel? u = UserModel.fromSnap(
                                  snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
                              return TextField(

                              );
                            },
                        )
                      )
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
