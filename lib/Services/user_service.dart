import 'package:cloud_firestore/cloud_firestore.dart';

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
}
