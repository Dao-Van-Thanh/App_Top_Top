import 'package:app/Model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallVideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int lastVisibleIndex = 0;
  int batchSize = 10;
  final _auth = FirebaseAuth.instance;
  late final User firebaseUser;

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
