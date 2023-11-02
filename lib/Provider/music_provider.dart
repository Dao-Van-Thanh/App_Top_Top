import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

import '../Model/music_model.dart';

class MusicProvider extends ChangeNotifier {
  final player = AudioPlayer();
  List<MusicModel> musics = [
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d00004851e787cffec20aa2a396a61647',
        title: 'Cruel Summer',
        linkUrl: 'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eb2a1.appspot.com/o/drive-breakbeat-173062.mp3?alt=media&token=4e0ef49a-9148-4f5e-b67c-abfc0d4fc4d1&_gl=1*80fy3e*_ga*MTUzMjk2MDg3My4xNjk1NjQxMDA4*_ga_CW55HF8NVT*MTY5ODg5NDYwMC4xMTEuMS4xNjk4ODk0NjY4LjU1LjAuMA..', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d00004851d20231861e86a6f74ef2393e',
        title: 'Water',
        linkUrl: 'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eb2a1.appspot.com/o/leonell-cassio-the-paranormal-is-real-ft-carrie-163742.mp3?alt=media&token=e4ee32f7-0f9c-42df-b23e-2a1f5cc005ef&_gl=1*1wd51lt*_ga*MTUzMjk2MDg3My4xNjk1NjQxMDA4*_ga_CW55HF8NVT*MTY5ODg0NjgyMy4xMDkuMS4xNjk4ODQ3MTY0LjYwLjAuMA..', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d0000485122fd802bc61db666c7c81aa8',
        title: 'greedy',
        linkUrl: 'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eb2a1.appspot.com/o/science-documentary-169621.mp3?alt=media&token=9c5dad27-521a-49c8-942e-6f2652569dd0&_gl=1*ch2n8k*_ga*MTUzMjk2MDg3My4xNjk1NjQxMDA4*_ga_CW55HF8NVT*MTY5ODg0NjgyMy4xMDkuMS4xNjk4ODQ3MTc5LjQ1LjAuMA..', isFocus: false),
    MusicModel(
        thumb:
        'https://i.scdn.co/image/ab67616d000048517acee948ecac8380c1b6ce30',
        title: 'Paint The Town Red',
        linkUrl: 'https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eb2a1.appspot.com/o/inside-you-162760.mp3?alt=media&token=a728e6af-99e0-49f0-aae7-9467d5664ff2&_gl=1*12iz0y4*_ga*MTUzMjk2MDg3My4xNjk1NjQxMDA4*_ga_CW55HF8NVT*MTY5ODg0NjgyMy4xMDkuMS4xNjk4ODQ3MjMzLjUzLjAuMA..', isFocus: false),
  ];

  String? _linkUrl;
  String get linkUrl => _linkUrl!;
  void initAudioPlayer(int index) async{
    await player.setUrl(musics[index].linkUrl);
    player.play();
    _linkUrl = musics[index].linkUrl;
  }
  bool isCheckMusicPlay = false;
  void setIsCheckMusicPlay(){
    isCheckMusicPlay = true;
  }
  void initAudioPlayerForScreenVideo(String songUrl) async{
    await player.setUrl(songUrl);
    player.play();
  }
  void stopAudio(){
    player.stop();
  }
  void playAudio(){
    player.play();
  }
  void pauseAudio(){
    player.pause();
  }
  void toggleMusicFocus(int index) async{
      for(int i=0;i<musics.length;i++){
        if(i == index){
          continue;
        }
        musics[i].isFocus = false;
      }
      musics[index].isFocus = !musics[index].isFocus;
    notifyListeners();
  }
  void dispose() {
    super.dispose();
  }
}