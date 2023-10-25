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
  int views;

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
        required this.views,
        required this.blockComments,
        required this.profilePhoto});

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
    "views": views,
    "blockComments": blockComments,
    "videoUrl": videoUrl,
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
      views: snapshot['views'],
      blockComments: snapshot['blockComments'],
      profilePhoto: snapshot['profilePhoto'],
    );
  }
}
