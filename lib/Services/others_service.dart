import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OthersService {
  static Stream<DocumentSnapshot> getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userRef =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    return userRef.snapshots();
  }

  Future<void> FollowOther(String idOther) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'following': FieldValue.arrayUnion([idOther])
      });
      await FirebaseFirestore.instance.collection('Users').doc(idOther).update({
        'follower': FieldValue.arrayUnion([user.uid])
      });
      await createChatRoomsForUsers(user, idOther);
    } catch (e) {
      print('Lỗi khi cập nhật trường following: $e');
    }
  }

  void UnFollowOther(String idOther) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'following': FieldValue.arrayRemove([idOther])
      });
      await FirebaseFirestore.instance.collection('Users').doc(idOther).update({
        'follower': FieldValue.arrayRemove([user.uid])
      });
    } catch (e) {
      print('Lỗi khi cập nhật trường following: $e');
    }
  }


  // hàm tạo phòng chat
  Future<void> createChatRoomsForUsers(user, idOther) async {
    try {
      bool checkPhong = false;
      if (user == null) {
        throw Exception('User is not logged in');
      }
      // 1. Xác định danh sách following và follower của người dùng hiện tại.
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final userSnapshot = await userDoc.get();
      final List<String> following =
          List<String>.from(userSnapshot['following'] ?? []);
      final List<String> follower =
          List<String>.from(userSnapshot['follower'] ?? []);

      // 2. Truy cập bảng Chats và kiểm tra từng phòng chat.
      final chatsCollection = FirebaseFirestore.instance.collection('Chats');
      final querySnapshot = await chatsCollection.get();
      final existingChatRooms = querySnapshot.docs;
      // kiểm tra nếu cả 2 chũng follow thì tạo phòng chat
      final checkFollow = following.contains(idOther) && follower.contains(idOther);
      if (checkFollow) {
        // 2. Truy cập bảng Chats và kiểm tra từng phòng chat.
        for (final chatRoom in existingChatRooms) {
          final chatData = chatRoom.data();

          //kiểm tra xem có phòng chat nào không nếu không:
          // => chưa tồn tại phòng chat
          if(chatData.isEmpty){
            break;
          }else{
            final List<String> chatUid = List<String>.from(chatData['uid']);
            // Kiểm tra xem danh sách chatUid chứa cả hai ID.
            if (chatUid.contains(user.uid) && chatUid.contains(idOther)) {
              checkPhong = true;
              break;  // Nếu đã tìm thấy phòng chat phù hợp, không cần kiểm tra thêm.
            }
          }
        }
      }
      if(checkFollow && checkPhong == false){
        // 3. Nếu không có phòng chat thỏa mãn, tạo phòng chat mới.
        // Tạo mảng chứa cả hai ID.
        final idsToAdd = [user.uid, idOther];
        // Thêm cả hai ID vào mảng 'uid' của các tài khoản Chats.
        await chatsCollection.add({
          'uid': FieldValue.arrayUnion(idsToAdd),
          'messages': {}
          // Thêm các trường dữ liệu khác của phòng chat (nếu cần).
        });
      }
    } catch (e) {
      print('==================$e');
    }
    // Làm bất cứ điều gì bạn muốn sau khi tạo phòng chat (ví dụ: điều hướng đến phòng chat).
  }
}
