import 'package:app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  Stream<DocumentSnapshot> getCmtVideo(String videoId) {
    try {
      final stream = FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoId)
          .snapshots();
      return stream;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }

  Future<void> sendCmt(String videoId, String comment, String uId) async {
    final videoCollection = FirebaseFirestore.instance.collection("Videos");
    try {
      final commentId = FirebaseFirestore.instance
          .collection("Videos")
          .doc()
          .id;
      Map<String, dynamic> commentData = {
        'id': commentId,
        'uid': uId,
        'text': comment,
        'timestamp': DateTime.now(),
      };
      await videoCollection.doc(videoId).update({
        'comments': FieldValue.arrayUnion([commentData]),
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }

  // Future<void> repliesCmt(String commentId,String uId,String commnet){
  //   final videoCollection = FirebaseFirestore.instance.collection("Videos");
  //   try{
  //     Map<String,dynamic> repliesCMT={
  //       'uid':uId,
  //       'replies':commnet,
  //     }
  //     return '';
  //   }catch (e) {
  //     // Xử lý lỗi nếu có
  //     print('Lỗi: $e');
  //     throw e; // Rethrow lỗi nếu cần
  //   }
  // }
  Future<UserModel?> getUserDataForUid(String uid) async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection(
        'Users') // Thay đổi tên bảng Firestore theo thiết lập của bạn
        .doc(uid)
        .get();
    if (userDataSnapshot.exists) {
      final userModel = UserModel.fromSnap(userDataSnapshot);
      return userModel;
    } else {
      return null; // Hoặc giá trị mặc định khác tùy theo bạn
    }
  }

  Future<String?> getAvatarUrl(String uid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userDoc = await firestore.collection('Users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String? avatarUrl = userDoc.get('avatarURL');
        return avatarUrl;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }

  Future<void> deleteCmt(String videoId, String commentId) async {
    final videoDocRef = FirebaseFirestore.instance.collection("Videos").doc(
        videoId);

    try {
      final videoDoc = await videoDocRef.get();
      if (videoDoc.exists) {
        List<dynamic> comments = videoDoc.data()?['comments'];

        if (comments != null) {
          final updatedComments = comments.where((comment) =>
          comment['id'] != commentId).toList();

          await videoDocRef.update({'comments': updatedComments});
          print('Xóa bình luận thành công');
        } else {
          print('Không có danh sách bình luận.');
        }
      } else {
        print('Không tìm thấy tài liệu video');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw e;
    }
  }
}