import 'package:app/Services/call_video_service.dart';
import 'package:share_plus/share_plus.dart';

class ShareVideo{
  static void shareVideo(String idVideo,String videoUrl) async {
    final result = await Share.shareWithResult(videoUrl);
    if (result.status == ShareResultStatus.success) {
      CallVideoService().addShareCountInTablesVideo(idVideo);
    }
  }
}