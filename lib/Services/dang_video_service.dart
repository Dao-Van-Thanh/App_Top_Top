import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

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
      debugPrint('Lỗi khi tải lên video: $error');
      return null;
    }
  }

  // hàm thêm video vào bảng videos
  Future<void> _addVideoToFirestore(String videoUrl, String caption,bool blockComments, String songUrl) async {
    if (user == null) {
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
        'songUrl':songUrl,
        'caption': caption,
        'videoUrl': videoUrl,
        'blockComments': blockComments,
        'status':true,
        'views' : 0,
        'userSaveVideos' : [],
        'profilePhoto': userDoc['avatarURL'], // Sử dụng userDoc để lấy avatarURL
      });
      debugPrint('Video đã được thêm vào Firestore.');
    } catch (error) {
      debugPrint('Lỗi khi thêm video vào Firestore: $error');
    }
  }


  // hàm chính: đăng video
  Future<bool> dangVideo(String caption,bool blockComments,XFile file, String musicChoose) async {
      try{
        String videoUrl = await _uploadVideoToStorage(file) ?? '';
        if(videoUrl.isNotEmpty){
          await _addVideoToFirestore(videoUrl,caption,blockComments,musicChoose);
          return true;
        }else{
          return false;
        }
      }catch(error){
        return false;
      }
  }
}