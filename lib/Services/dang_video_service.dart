import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DangVideoService{
  final user = FirebaseAuth.instance.currentUser;

  // // hàm nén video
  // static compressVideo(String videoPath) async {
  //   try {
  //     final compressedVideo = await VideoCompress.compressVideo(
  //       videoPath,
  //       quality: VideoQuality.MediumQuality,
  //     );
  //     return compressedVideo!.file;
  //   } catch (e) {
  //     throw Exception("CompressVideo:________________________$e");
  //   }
  // }

  // hàm cho video vào storage
  Future<String?> _uploadVideoToStorage(XFile videoFile) async {
    if (user == null) {
      print('Người dùng chưa đăng nhập.');
      return '';
    }
    final storage = FirebaseStorage.instance;
    final videoRef =
        storage
        .ref()
        .child('Videos/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.mp4');
    final UploadTask uploadTask =
        videoRef.putFile(File(videoFile.path));

    try {
      final TaskSnapshot snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Lỗi khi tải lên video: $error');
      return null;
    }
  }

  // hàm thêm video vào bảng videos
  Future<void> _addVideoToFirestore(String videoUrl, String caption,bool blockComments) async {
    if (user == null) {
      print('Người dùng chưa đăng nhập.');
      return;
    }

    final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

    final CollectionReference videosCollection =
      FirebaseFirestore.instance.collection('Videos');
    try {
      await videosCollection.add({
        'username': userDoc['fullname'], // Sử dụng userDoc để lấy fullname
        'uid': user!.uid,
        'likes': [],
        'comments': [],
        'shareCount': 0,
        'songName': 'Tên bài hát',
        'caption': caption,
        'videoUrl': videoUrl,
        'blockComments': blockComments,
        'views' : 0,
        'userSaveVideos' : [],
        'profilePhoto': userDoc['avatarURL'], // Sử dụng userDoc để lấy avatarURL
      });
      print('Video đã được thêm vào Firestore.');
    } catch (error) {
      print('Lỗi khi thêm video vào Firestore: $error');
    }
  }


  // hàm chính: đăng video
  Future<bool> DangVideo(String caption,bool blockComments,XFile file) async {
      try{
        String videoUrl = await _uploadVideoToStorage(file) ?? '';
        if(videoUrl.isNotEmpty){
          await _addVideoToFirestore(videoUrl,caption,blockComments);
          return true;
        }else{
          return false;
        }
      }catch(error){
        return false;
      }
  }
}