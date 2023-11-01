import 'dart:io';

import 'package:app/Services/notifications_service.dart';
import 'package:app/Services/others_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/user_model.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Lấy thông tin user
  Future<Map<String, dynamic>?> getDataUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> followUser( String targetUserID) async {
    OthersService service = OthersService();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        final firestoreInstance = FirebaseFirestore.instance;
        await firestoreInstance.collection('Users').doc(user.uid).update({
          'following': FieldValue.arrayUnion([targetUserID]),
        });
        await firestoreInstance.collection('Users').doc(targetUserID).update({
          'follower': FieldValue.arrayUnion([user.uid]),
        });
        NotificationsService notificationsService = NotificationsService();
        final data = await getDataUser();
        print('======================');
        notificationsService.sendNotification(
            title: data!['fullname'],
            body: 'Đã follow bạn',
            idOther: targetUserID
        );
        service.createChatRoomsForUsers(user, targetUserID);
      }
    } catch (e) {
      print("Error following user: $e");
    }
  }

  Future<void> unfollowUser(String targetUserID) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        final firestoreInstance = FirebaseFirestore.instance;
        await firestoreInstance.collection('Users').doc(user.uid).update({
          'following': FieldValue.arrayRemove([targetUserID]),
        });

        await firestoreInstance.collection('Users').doc(targetUserID).update({
          'follower': FieldValue.arrayRemove([user.uid]),
        });
      }
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> getListFriend() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        final firestoreInstance = FirebaseFirestore.instance;
        final userCollection = firestoreInstance.collection('Users');

        QuerySnapshot userSnapshot = await userCollection.get();

        List<Map<String, dynamic>> usersList = [];

        // Lấy danh sách người bạn đã theo dõi một lần
        final followingList =
        await getFollowingList(user.uid);
        for (var userDoc in userSnapshot.docs) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          final targetUserID = userData['uid'].toString();
          // Kiểm tra xem người dùng có trong danh sách bạn bè đã theo dõi chưa
          if (!followingList.contains(targetUserID) &&
              targetUserID != user.uid) {
            usersList.add(userData);

          }
        }
        return usersList;
      }
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
  Future<List<String>> getFollowerList(String currentUserID) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentSnapshot currentUserDoc =
      await firestoreInstance.collection('Users').doc(currentUserID).get();
      if (currentUserDoc.exists) {
        Map<String, dynamic> currentUserData =
        currentUserDoc.data() as Map<String, dynamic>;
        List<String> followingList =
        List<String>.from(currentUserData['follower']);
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
      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(File(file.path));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("uploadImageToStorage:________________________$e");
    }
  }



  Future uploadFile(File file,String documenId) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Users');
    try{
      String imageUrl = await uploadFileToStorege(file);
        final userDoc = users.doc(documenId);

      await userDoc.update({
        "avatarURL": imageUrl,
      });
    } catch (e) {
      print('Lỗi khi cập nhật dữ liệu người dùng: $e');
    }
  }

  Stream<DocumentSnapshot> getUser(String documenId) {
    try {
      final stream = FirebaseFirestore.instance
          .collection('Users')
          .doc(documenId)
          .snapshots();
      return stream;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }
  Future<DocumentSnapshot> getUserFollow(String documenId) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documenId)
          .get();
      return document;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }

  static Future<void> signOutUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');
      // Đăng xuất người dùng khỏi Firebase Auth
      await _auth.signOut();
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
    }
  }

  static Future<void> updateStatusUser(Map<String,dynamic> data) async{
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
  static String formattedTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  static Future<bool> checkUserOnline({required String uid}) async {
    final document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();
    if (document.exists) {
      final userData = document.data() as Map<String, dynamic>?;
      if (userData != null) {
        // Trường 'isOnline' tồn tại và là kiểu bool
        bool isOnline = userData['isOnline'];
        return isOnline;
      }
    }
    return false;
  }

  Future<void> getCurrentLocation(String uid) async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      // Người dùng đã cấp quyền, có thể lấy vị trí.
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Vị trí: $position');
    } else {
      if (status.isGranted) {
        // Quyền chưa được cấp, yêu cầu người dùng.
        var result = await Permission.location.request();
        if (result.isGranted) {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print('Vị trí: $position');
        } else {
          // Xử lý trường hợp người dùng từ chối quyền.
          print('Người dùng từ chối quyền vị trí.');
        }
      } else {
        // Người dùng đã từ chối hoặc vô hiệu hóa quyền.
        // Hướng dẫn người dùng mở cài đặt để cấp quyền.
        openAppSettings();
      }
    }
  }
}
