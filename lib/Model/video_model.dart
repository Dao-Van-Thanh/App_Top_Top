import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String uid;
  String id;
  List likes;
  List comments;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String profilePhoto;
  bool blockComments;
  bool status;
  int views;
  List<String>? userSaveVideos;

  VideoModel(
      {required this.username,
        required this.uid,
        required this.id,
        required this.likes,
        required this.comments,
        required this.shareCount,
        required this.songName,
        required this.caption,
        required this.videoUrl,
        required this.blockComments,
        required this.status,
        required this.views,
        required this.profilePhoto,
        this.userSaveVideos});

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "profilePhoto": profilePhoto,
    "id": id,
    "likes": likes,
    "comments": comments,
    "shareCount": shareCount,
    "songName": songName,
    "caption": caption,
    "blockComments": blockComments,
    "status":status,
    "views": views,
    "videoUrl": videoUrl,
    "userSaveVideos": [],
  };

  static VideoModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VideoModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snap.id,
      likes: snapshot['likes'],
      comments: snapshot['comments'],
      shareCount: snapshot['shareCount'],
      songName: snapshot['songName'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      blockComments: snapshot['blockComments'],
      status: snapshot['status'],
      views: snapshot['views'],
      profilePhoto: snapshot['profilePhoto'],
      userSaveVideos: (snapshot['userSaveVideos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
