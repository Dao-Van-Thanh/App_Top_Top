import 'package:flutter/material.dart';

class FollowProvider extends ChangeNotifier {
  bool isNotFollowed = true;
  bool isFollowed = true;

  isAcctionFollowed() {
    isFollowed = isFollowed == false ? true : false;
    notifyListeners();
  }

  unFollow() {
    isFollowed = true;
    notifyListeners();
  }

  isFollowing() {
    isFollowed = false;
    notifyListeners();
  }
}
