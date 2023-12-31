import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminService{
  Future<bool> getBanUid(String uid)async{
    try{
      final document = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get();
      if(document.exists){
        final userData = document.data();
        bool isBan = userData?['ban'];
        return isBan;
      }
      return false;
    }catch (e) {
      // Xử lý lỗi nếu có
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
    }
  }
  Future<void> banUser(String uid,bool status)async{
    try{
      final useRef = FirebaseFirestore.instance
          .collection("Users").doc(uid);
      final  useDoc = await useRef
          .get();
      if(useDoc.exists){
        await useRef.update(({'ban':status}));
      } else {
        await useRef.set({'ban': true});
      }
    }catch (e) {
      // Xử lý lỗi nếu có
      debugPrint('Lỗi: $e');
      rethrow; // Rethrow lỗi nếu cần
    }
  }
}