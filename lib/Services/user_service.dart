import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? currentUserId;

  // Lấy thông tin user
  Future<Map<String, dynamic>?> getDataUser(String userId) async {
    currentUserId = userId;
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>;
        return userData;
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }

  // Chỉnh sửa thông tin user
  Future<void> editDataUser(String label, String value) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Users');

    try {
      final userDoc = users.doc('lxCeVjiVu3YeZcgjZJ3fN8TAGBG2');
      Map<String, dynamic> updateData = {};
      switch (label) {
        case 'Tên':
          updateData['fullname'] = value;
          break;
        case 'Tiểu sử':
          updateData['bio'] = value;
          break;
        case 'TikTok ID':
          updateData['idTopTop'] = value;
          break;
        default:
          return;
      }
      await userDoc.update(updateData);
    } catch (e) {
      print('Lỗi khi cập nhật dữ liệu người dùng: $e');
    }
  }

    Future uploadFileToStorege(File file) async {
      try {
        final path = 'images/${file.path}';
        final ref = FirebaseStorage.instance.ref().child(path);
        UploadTask uploadTask = ref.putFile(File(file.path));
        TaskSnapshot snap = await uploadTask;
        String downloadUrl = await snap.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        throw Exception("uploadImageToStorage:________________________$e");
      }
    }

  Future uploadFile(File file) async {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String imageUrl = await uploadFileToStorege(file);
      final collectionRef = firestore.collection('Users').doc(currentUser.uid);
      await collectionRef.update({
        "avatarUrl": imageUrl,
      });
    } else {
      // Xử lý trường hợp người dùng chưa đăng nhập
      print("Người dùng chưa đăng nhập.");
    }
  }
  Future<String?> getAvatar(String documenId) async{
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documenId)
          .get();
      if (documentSnapshot.exists) {
        String? avatarUrl = documentSnapshot['avatarUrl'];
        return avatarUrl;
      } else {
        return null;
      }
    }catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi lấy avatarUrl: $e');
      return null;
    }
  }
  }
