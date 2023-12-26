import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../Model/comment_model.dart';

class CommentsProviderTemp {
  final isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final listCommentsSubject = BehaviorSubject<List<CommentModel>>.seeded([]);

  CommentsProviderTemp(String idVideo) {
    init(idVideo);
  }

  void init(String idVideo) {
    isLoadingSubject.value = true;
    FirebaseFirestore.instance.collection("Videos").doc(idVideo).get().then(
      (DocumentSnapshot document) async {
        if (document.exists) {
          // Kiểm tra xem tài liệu có tồn tại không
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          List<CommentModel> ls = [];
          List<String> lsIdComment = [...data['comments']];

          if (lsIdComment.isNotEmpty) {
            ls = await Future.wait(
              lsIdComment.map((e) async {
                final cm = await FirebaseFirestore.instance
                    .collection("Videos")
                    .doc(idVideo)
                    .collection("Comments")
                    .doc(e)
                    .get();
                return CommentModel.fromSnapshot(cm);
              }),
            );
          }
          listCommentsSubject.value = [...ls];
          isLoadingSubject.value = false;
        } else {}
      },
    );
  }

  void dispose() {
    isLoadingSubject.close();
    listCommentsSubject.close();
  }
}
