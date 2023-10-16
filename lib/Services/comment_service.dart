import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService{
  Stream<DocumentSnapshot> getCmtVideo(String videoId){
    try{
      final stream = FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoId)
          .snapshots();
      return stream;
    }catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }
  Future<void> sendCmt(String videoId,String comment,String uId) async{
    final videoCollection = FirebaseFirestore.instance.collection("Videos");
    try{
      final commentId = FirebaseFirestore.instance
          .collection("Videos")
          .doc()
          .id;
      Map<String,dynamic>  commentData ={
        'id': commentId,
        'uid': uId,
        'text':comment,
        'timestamp': DateTime.now(),
      };
      await videoCollection.doc(videoId).update({
        'comments': FieldValue.arrayUnion([commentData]),
      });
    }catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi: $e');
      throw e; // Rethrow lỗi nếu cần
    }
  }
  Future<List<Map<String, dynamic>>?> getUserDataForMultipleUIDs(List<String> uIds) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('Users');

      List<Map<String, dynamic>> userData = [];

      for (String uid in uIds) {
        DocumentSnapshot userDoc = await userCollection.doc(uid).get();
        Map<String, dynamic>? userDataMap = userDoc.data() as Map<String, dynamic>?;

        if (userDataMap != null) {
          userData.add(userDataMap);
        }
      }

      return userData;
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }
  Future<String?> getUserUrl(String uid) async{
    try{
      final userConnect = FirebaseFirestore.instance.doc(uid);
      final userData = await userConnect.get();
      if (userData.exists) {
        final urlImage = userData.data()?['avatarURL'] as String;
        return urlImage;
      } else {
        // Handle the case where the document with the provided UID doesn't exist.
        return null;
      }
    }catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }
}