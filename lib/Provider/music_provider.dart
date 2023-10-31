import 'package:flutter/cupertino.dart';

import '../Model/music_model.dart';

class MusicProvider extends ChangeNotifier {
  List<MusicModel> musics = [
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d00004851e787cffec20aa2a396a61647',
        title: 'Cruel Summer',
        linkUrl: 'linkUrl', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d00004851d20231861e86a6f74ef2393e',
        title: 'Water',
        linkUrl: 'linkUrl', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d0000485122fd802bc61db666c7c81aa8',
        title: 'greedy',
        linkUrl: 'linkUrl', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d000048517acee948ecac8380c1b6ce30',
        title: 'Paint The Town Red',
        linkUrl: 'linkUrl', isFocus: false),


  ];

  void toggleMusicFocus(int index) {
    musics[index].isFocus = !musics[index].isFocus;
    notifyListeners();
  }
}