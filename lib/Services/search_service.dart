import 'package:app/Model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCaptionsFromVideos() async {
    try {
      final querySnapshot = await _firestore.collection('Videos').get();
      final captions = querySnapshot.docs.map((doc) {
        return doc.data()['caption'] as String;
      }).toList();
      return captions;
    } catch (e) {
      debugPrint('Error fetching data: $e');
      throw Exception('Failed to load captions from Firestore');
    }
  }
  Future<List<String>> getFollowingList() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot docUser = await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      Map<String,dynamic> data = docUser.data() as Map<String,dynamic>;
      List<String> idFollowing = data['following'] !=null
          ? List<String>.from(data['following'])
          : [];
      return idFollowing;
    } catch (e) {
      debugPrint('Error fetching following list: $e');
      rethrow;
    }
  }
  // Future<String> getUserById(String uid) async{
  //   try{
  //     DocumentSnapshot docUser = await FirebaseFirestore.instance.collection("Users").doc(uid).get();
  //     return 'null';
  //   }catch (e) {
  //     print('Error fetching following list: $e');
  //     rethrow;
  //   }
  // }
Stream<List<VideoModel>> getVideosByCaption(String caption) {
  return _firestore.collection('Videos')
      .where('caption', isEqualTo: caption)
      .snapshots()
      .map((querySnapshot) {
    List<VideoModel> videoList = [];
    for (var doc in querySnapshot.docs) {
      videoList.add(VideoModel.fromSnap(doc));
    }
    return videoList;
  });
}
  Future<void> saveListHistory(List<String> dataList) async {
    (dataList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myList', dataList);
  }
  Future<List<String>> getListHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('myList');
    return dataList ?? [];
  }


}
