import 'package:app/Model/user_model.dart';
import 'package:app/Model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallVideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int lastVisibleIndex = 0;
  int batchSize = 10;
  final _auth = FirebaseAuth.instance;

  Future<List<UserModel>> getFollowingUsers() async {
    List<UserModel> followingUsers = [];
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data['following'] != null) {
        final followingUIDs = List<String>.from(data['following']);

        for (String uid in followingUIDs) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .get();
          if (userSnapshot.exists) {
            followingUsers.add(UserModel.fromSnap(userSnapshot));
          }
        }
      }
    }
    print(followingUsers);
    return followingUsers;
  }



  Stream<List<VideoModel>> getVideosFollowingStream() async* {
    final followingUserUIDs = await getFollowingUsers();
    if (followingUserUIDs.isEmpty) {
      yield <VideoModel>[]; // Trả về danh sách rỗng nếu không có người bạn đang follow
      return;
    }
    final videoLists = await Future.wait(followingUserUIDs.map((uid) async {
      final querySnapshot = await _firestore
          .collection('Videos')
          .where('uid', isEqualTo: uid)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) => VideoModel.fromSnap(doc)).toList();
    }));

    final mergedVideoList = videoLists.expand((videos) => videos).toList();

    yield mergedVideoList;
  }

  Stream<List<VideoModel>> getVideosStream() {
    return _firestore.collection('Videos').limit(10).snapshots().map((snapshot) {
      List<VideoModel> videoList = [];
      snapshot.docs.forEach((doc) {
        videoList.add(VideoModel.fromSnap(doc));
      });
      return videoList;
    });
  }

  Future<bool> checkLike(List<String> isdUserLiked) {
    for (var element in isdUserLiked) {
      if (element == _auth.currentUser!.uid) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await _firestore.collection('Videos').doc(id).get();
    var uid = _auth.currentUser!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await _firestore.collection('Videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _firestore.collection('Videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
