// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
//
// class AdPage extends StatefulWidget {
//   const AdPage({Key? key}) : super(key: key);
//
//   @override
//   State<AdPage> createState() => _AdPageState();
// }
//
// class _AdPageState extends State<AdPage> {
//   InterstitialAd? interstitialAd;
//   bool isInterstitialAdLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadInterstitial();
//   }
//
//   void loadInterstitial() {
//     InterstitialAd.load(
//       adUnitId: "ca-app-pub-8030355202927850/2904302880",
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           print("Ad Loaded");
//           setState(() {
//             interstitialAd = ad;
//             isInterstitialAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (error) {
//           print("Ad Failed to Load");
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             if (isInterstitialAdLoaded) {
//               interstitialAd!.show();
//             }
//           },
//           child: const Text("Show Ads"),
//         ),
//       ),
//     );
//   }
// }
