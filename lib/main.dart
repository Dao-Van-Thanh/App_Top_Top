import 'package:app/Provider/dang_ky_email_provider.dart';
import 'package:app/Provider/dang_ky_sdt_provider.dart';
import 'package:app/Provider/dang_nhap_facebook_provider.dart';
import 'package:app/Provider/edit_item_profile_provider.dart';
import 'package:app/Provider/edit_profile_provider.dart';
import 'package:app/Provider/comments_provider.dart';
import 'package:app/Provider/follow_provider.dart';
import 'package:app/Provider/gui_data_provider.dart';
import 'package:app/Provider/load_videoProvider.dart';
import 'package:app/Provider/music_provider.dart';
import 'package:app/Provider/page_provider.dart';
import 'package:app/Provider/profile_provider.dart';
import 'package:app/Provider/quay_video_provider.dart';
import 'package:app/Provider/text_provider.dart';
import 'package:app/Provider/video_provider.dart';
import 'package:app/View/Pages/Profile/man_hinh_profile.dart';
import 'package:app/View/Pages/Profile/tab_admin.dart';
import 'package:app/View/Pages/QuayVideo/man_hinh_kiem_tra_video.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Provider/chats_provider.dart';
import 'Provider/dang_nhap_sdt_provider.dart';
import 'View/Screen/DangKy/man_hinh_dang_ky.dart';
import 'firebase_options.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyData()),
      ChangeNotifierProvider(create: (context) => DangNhapSdtProvider()),
      ChangeNotifierProvider(create: (context) => DangKySdtProvider()),
      ChangeNotifierProvider(create: (context) => DangKyEmailProvider()),
      ChangeNotifierProvider(create: (context) => EditItemProfileProvider()),
      ChangeNotifierProvider(create: (context) => EditProfileProvider()),
      ChangeNotifierProvider(create: (context) => FollowProvider()),
      ChangeNotifierProvider(create: (context) => QuayVideoProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ChangeNotifierProvider(create: (context) => VideoProvider()),
      ChangeNotifierProvider(create: (context) => TextProvider()),
      ChangeNotifierProvider(create: (context) => PageProvider()),
      ChangeNotifierProvider(create: (context) => ChatsProfiver()),
      ChangeNotifierProvider(create: (context) => CommentsProvider()),
      ChangeNotifierProvider(create: (context) => DangNhapFacebookProvider()),
      ChangeNotifierProvider(create: (context) => MusicProvider()),
      ChangeNotifierProvider(create: (context) => LoadVideoProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ManHinhProfile(),
      home: Bottom_Navigation_Bar(),
    );
  }
}
