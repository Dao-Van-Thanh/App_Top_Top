import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? currentUserId;

  // Lấy thông tin user
  Future<Map<String, dynamic>?> getDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentUserId = preferences.getString('uid');
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(currentUserId).get();
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
  Future<void> editDataUser(String uid,String label, String value) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Users');

    try {
      final userDoc = users.doc(uid);
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

  Future<void> followUser(String currentUserID, String targetUserID) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection('Users').doc(currentUserID).update({
        'following': FieldValue.arrayUnion([targetUserID]),
      });
    } catch (e) {
      print("Error following user: $e");
    }
  }

  Future<void> unfollowUser(String currentUserID, String targetUserID) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection('Users').doc(currentUserID).update({
        'following': FieldValue.arrayRemove([targetUserID]),
      });
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> getListFriend() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final userCollection = firestoreInstance.collection('Users');

      QuerySnapshot userSnapshot = await userCollection.get();

      List<Map<String, dynamic>> usersList = [];

      // Lấy danh sách người bạn đã theo dõi một lần
      final followingList =
          await getFollowingList('lxCeVjiVu3YeZcgjZJ3fN8TAGBG2');

      for (var userDoc in userSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        final targetUserID = userData['uid'].toString();

        // Kiểm tra xem người dùng có trong danh sách bạn bè đã theo dõi chưa

        if (!followingList.contains(targetUserID) &&
            targetUserID != 'lxCeVjiVu3YeZcgjZJ3fN8TAGBG2') {
          usersList.add(userData);
        }
      }

      return usersList;
    } catch (e) {
      print("Error getting users: $e");
      return null;
    }
  }

  Future<List<String>> getFollowingList(String currentUserID) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentSnapshot currentUserDoc =
          await firestoreInstance.collection('Users').doc(currentUserID).get();

      if (currentUserDoc.exists) {
        Map<String, dynamic> currentUserData =
            currentUserDoc.data() as Map<String, dynamic>;
        List<String> followingList =
            List<String>.from(currentUserData['following']);
        return followingList;
      }

      return [];
    } catch (e) {
      print("Error getting following list: $e");
      return [];
    }
  }

  Future uploadFileToStorege(File file) async {
    try {
      String filePath = file.path.split('/').last;
      final path = 'images/${filePath}';
      print(file.path);
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
    CollectionReference users = firestore.collection('Users');
    try{
      String imageUrl = await uploadFileToStorege(file);
      final userDoc = users.doc('sj8BOWfWdBZdVtI4dgNEO4hBVXD2');
      await userDoc.update({
        "avatarURL": imageUrl,
      });
    } catch (e) {
      print('Lỗi khi cập nhật dữ liệu người dùng: $e');
    }
  }

  Stream<DocumentSnapshot> getAvatar(String documenId) {
    try {
      final stream = FirebaseFirestore.instance
          .collection('Users')
          .doc(documenId)
          .snapshots();
      return stream;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi lấy avatarUrl: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }
}
