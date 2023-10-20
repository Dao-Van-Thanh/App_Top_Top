import 'package:app/Model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCaptionsFromVideos() async {
    try {
      final querySnapshot = await _firestore.collection('Videos').get();
      final captions = querySnapshot.docs.map((doc) {
        return doc.data()['caption'] as String;
      }).toList();
      return captions;
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load captions from Firestore');
    }
  }
Stream<List<VideoModel>> getVideosByCaption(String caption) {
  return _firestore.collection('Videos')
      .where('caption', isEqualTo: caption)
      .snapshots()
      .map((querySnapshot) {
    List<VideoModel> videoList = [];
    querySnapshot.docs.forEach((doc) {
      videoList.add(VideoModel.fromSnap(doc));
    });
    return videoList;
  });
}
  Future<void> saveListHistory(List<String> dataList) async {
    print(dataList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myList', dataList);
  }
  Future<List<String>> getListHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('myList');
    print(dataList);
    return dataList ?? [];
  }


}
