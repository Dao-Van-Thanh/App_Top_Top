import 'package:app/Model/user_model.dart';
import 'package:app/Model/video_model.dart';
import 'package:app/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallVideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int lastVisibleIndex = 0;
  int batchSize = 10;
  final _auth = FirebaseAuth.instance;

  Stream<List<VideoModel>> getVideosFollowingStream() async* {
    final followingUserUIDs = await UserService().getFollowingList(_auth.currentUser!.uid);
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
    return _firestore
        .collection('Videos')
        .snapshots()
        .map((snapshot) {
      List<VideoModel> videoList = [];
      snapshot.docs.forEach((doc) {
        videoList.add(VideoModel.fromSnap(doc));
      });
      return videoList;
    });
  }
  Stream<List<VideoModel>> getVideosStream1000() {
    return _firestore
        .collection('Videos')
        .orderBy('views', descending: true)
        .snapshots()
        .map((snapshot) {
      List<VideoModel> videoList = [];
      snapshot.docs.forEach((doc) {
        videoList.add(VideoModel.fromSnap(doc));
      });
      return videoList;
    });
  }
  Stream<List<VideoModel>> getVideosStreamByAuthor(String uid) {
    return _firestore.collection('Videos')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      List<VideoModel> videoList = [];
      querySnapshot.docs.forEach((doc) {
        videoList.add(VideoModel.fromSnap(doc));
      });
      return videoList;
    });
  }
  Stream<List<VideoModel>> getVideoBookmarks(String uid) {
    final CollectionReference videosCollection = FirebaseFirestore.instance.collection('Videos');
    return videosCollection
        .where('userSaveVideos', arrayContains: uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => VideoModel.fromSnap(doc))
          .toList();
    })
        .handleError((error) {
      print('Lỗi khi truy vấn dữ liệu từ Firestore: $error');
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
  Future<bool> checkUserSaveVideo(List<String> isdUserSave) {
    for (var element in isdUserSave) {
      if (element == _auth.currentUser!.uid) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }
  Future<bool> checkFollowing(String uid) async {
    List<String> userForllowingByAuthor = await UserService().getFollowerList(uid);
    for (var element in userForllowingByAuthor) {
      if (element == _auth.currentUser!.uid) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }
  Future<void> setView(String videoId) async{
    await _firestore.collection('Videos').doc(videoId).update({
      'views': FieldValue.increment(1)
    });
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
  Future<void> deleteVideo(String videoId) async {
    print(videoId);
    await _firestore.collection('Videos').doc(videoId).delete();
  }
  Future<void> updateVideoCaption(String videoId, String newCaption,bool blockComments) async {
    try {
      await _firestore.collection('Videos').doc(videoId).update({
        'caption': newCaption,
        'blockComments' : blockComments
      });
    } catch (error) {
      print('Error updating caption: $error');
    }
  }
   saveVideo(String videoId) async{
    DocumentSnapshot doc = await _firestore.collection('Users').doc(_auth.currentUser!.uid).get();
    if ((doc.data()! as dynamic)['saveVideos'].contains(videoId)) {
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
        'saveVideos': FieldValue.arrayRemove([videoId]),
      });
      await _firestore.collection('Videos').doc(videoId).update({
        'userSaveVideos': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });
    } else {
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
        'saveVideos': FieldValue.arrayUnion([videoId]),
      });
      await _firestore.collection('Videos').doc(videoId).update({
        'userSaveVideos': FieldValue.arrayUnion([_auth.currentUser!.uid]),
      });
    }
  }
  // Future<void> updateUrlVideo() async{
  //   await FirebaseFirestore.instance
  //       .collection('Videos')
  //       .doc()
  //       .update({
  //     'videoUrl' : 'https://a253-2a09-bac1-7a80-50-00-17-169.ngrok-free.app/uploads/1698302425463-Download%20(5).mp4'
  //   });
  // }

}
