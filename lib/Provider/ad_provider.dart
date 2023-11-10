// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:http/http.dart' as http;
//
// class AdProvider extends ChangeNotifier {
//   BannerAd? _bannerAd;
//
//   BannerAd? get bannerAd => _bannerAd;
//
//   set bannerAd(BannerAd? ad) {
//     _bannerAd = ad;
//     notifyListeners();
//   }
//
//   bool _loadingAd = false;
//
//   bool get loadingAd => _loadingAd;
//
//   set loadingAd(bool val) {
//     _loadingAd = val;
//     notifyListeners();
//   }
//
//   void loadAd(String adId) async {
//     loadingAd = true;
//     await _bannerAd?.dispose();
//     bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-8030355202927850/2904302880',
//       request: const AdRequest(),
//       size: const AdSize(width: 320, height: 480),
//       listener: BannerAdListener(
//         onAdLoaded: (_) {},
//         onAdClicked: (_) {},
//         onAdImpression: (ad) {},
//         onAdFailedToLoad: (ad, err) {},
//       ),
//     );
//     await _bannerAd?.load();
//     loadingAd = false;
//   }
//
//   void disposeAd() {
//     _bannerAd?.dispose();
//     _bannerAd = null;
//   }
// }