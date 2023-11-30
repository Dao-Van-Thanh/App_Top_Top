import 'package:app/Model/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'notifications_service.dart';

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
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
    }
  }
  Stream<DocumentSnapshot> getReCommentsInComment(String videoId,String idComment) {
    try {
      final stream = FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoId)
          .collection("Comments")
          .doc(idComment)
          .snapshots();
      return stream;
    } catch (e) {
      // Xử lý lỗi nếu có
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
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
      var videoSnapshot = await videoCollection.get();
      if(videoSnapshot.data()?['uid'] != uId){
        NotificationsService().createNotification(videoSnapshot.data()?['uid'], uId, 'comment');
      }

    } catch (e) {
      // Xử lý lỗi nếu có
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
    }
  }
  Future<void> sendReComment(String videoId,String idComment, String comment, String uId) async {
    try {
      // thêm comment vào collection Comments
      final recommentCollection = FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoId)
          .collection('Comments')
          .doc(idComment)
          .collection('Recomments');

      // Tạo một đối tượng Comment từ dữ liệu comment
      CommentModel commentData = CommentModel(
        id: '',
        uid: uId,
        text: comment,
        likes: [],
        recomments: [],
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      // Chuyển đối tượng Comment thành một Map
      Map<String, dynamic> commentMap = commentData.toJson();

      // Thêm một comment mới vào collection 'Comments'
      final commentDocRef = await recommentCollection.add(commentMap);
      final notification = FirebaseFirestore.instance.collection("Notification");
      // thêm comment vào trường comments trong bảng Videos
      final commentCollection =
      FirebaseFirestore.instance
          .collection('Videos')
          .doc(videoId)
          .collection('Comments')
          .doc(idComment);
      commentCollection.update({
        'recomments': FieldValue.arrayUnion([commentDocRef.id])
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
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
  Future<void> likeReComment(String idVideo, String idComment,String idReComment, bool liked) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .collection('Recomments')
        .doc(idReComment)
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
  Future<void> removeReComment(String idVideo, String idComment,String idRecomment) async {
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .update({
      'recomments' : FieldValue.arrayRemove([idRecomment])
    });
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .collection('Recomments')
        .doc(idRecomment)
        .delete();

  }

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
      debugPrint('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }

  Stream<DocumentSnapshot> getCommentById(String idVideo, String idComment) {
    return FirebaseFirestore.instance
        .collection('Videos')
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .snapshots();
  }
  Stream<DocumentSnapshot> getReCommentById(String idVideo, String idComment,String idReComment) {
    return FirebaseFirestore.instance
        .collection('Videos')
        .doc(idVideo)
        .collection('Comments')
        .doc(idComment)
        .collection('Recomments')
        .doc(idReComment)
        .snapshots();
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
  Future<void> updateReComment(String idVideo, String idComment,String idRecomment,String commentUpdate) async {
      await FirebaseFirestore.instance
          .collection('Videos')
          .doc(idVideo)
          .collection('Comments')
          .doc(idComment)
          .collection('Recomments')
          .doc(idRecomment)
          .update({
            'text' : commentUpdate
      });
  }

}
