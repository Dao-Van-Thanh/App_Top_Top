import 'package:app/Model/comment_model.dart';
import 'package:app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  Stream<DocumentSnapshot> getCommentsInVideo(String videoId) {
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

  Future<void> sendComment(String videoId, String comment, String uId) async {
    try {
      // thêm comment vào collection Comments
      final commentCollection = FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoId)
          .collection('Comments');

      // Tạo một đối tượng Comment từ dữ liệu comment
      CommentModel commentData = CommentModel(
        id: '',
        // Id sẽ được Firebase tạo tự động
        uid: uId,
        text: comment,
        likes: [],
        recomments: [],
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      // Chuyển đối tượng Comment thành một Map
      Map<String, dynamic> commentMap = commentData.toJson();

      // Thêm một comment mới vào collection 'Comments'
      final commentDocRef = await commentCollection.add(commentMap);

      // thêm comment vào trường comments trong bảng Videos
      final videoCollection =
          FirebaseFirestore.instance.collection('Videos').doc(videoId);
      videoCollection.update({
        'comments': FieldValue.arrayUnion([commentDocRef.id])
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }

  Future<void> likeComment(String idVideo, String idComment, bool liked) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .update({
      'likes':
          liked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid])
    });
  }

  Future<void> removeComment(String idVideo, String idComment) async {
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .update({
      'comments' : FieldValue.arrayRemove([idComment])
    });
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .delete();

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

  Future<String?> getAvatarUrl(String uid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(uid).get();

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

  Stream<DocumentSnapshot> getCommentById(String idVideo, String idComment) {
    final commentSnap = FirebaseFirestore.instance
        .collection('Videos')
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .snapshots();
    return commentSnap;
  }

  Future<void> updateComment(String idVideo, String idComment,String commentUpdate) async {
      await FirebaseFirestore.instance
          .collection('Videos')
          .doc(idVideo)
          .collection('Comments')
          .doc(idComment)
          .update({
            'text' : commentUpdate
      });
  }


}
