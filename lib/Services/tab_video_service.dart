import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Model/video_model.dart';

class TabVideoService{

  // static Future<List<String>> getVideoUrls() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final storage = FirebaseStorage.instance;
  //   final videoRef = storage.ref().child('Videos/${user!.uid}');
  //
  //   try {
  //     final ListResult result = await videoRef.list();
  //     final List<String> videoUrls = [];
  //
  //     for (final ref in result.items) {
  //       final downloadUrl = await ref.getDownloadURL();
  //       videoUrls.add(downloadUrl);
  //     }
  //
  //     return videoUrls;
  //   } catch (error) {
  //     print('Lỗi khi truy cập vào storage: $error');
  //     return [];
  //   }
  // }
  static Future<List<VideoModel>> getVideosByUid(String uid) async {
    try {
      final CollectionReference videosCollection =
      FirebaseFirestore.instance.collection('Videos');

      final QuerySnapshot querySnapshot = await videosCollection
          .where('uid', isEqualTo: uid) // Điều kiện trường 'uid' bằng UID cụ thể
          .get();

      final List<VideoModel> videos = querySnapshot.docs
          .map((doc) => VideoModel.fromSnap(doc))
          .toList();
      return videos;
    } catch (error) {
      print('Lỗi khi truy vấn dữ liệu từ Firestore: $error');
      return [];
    }
  }

}