import 'dart:convert';

import 'package:app/Enum/enum_notification.dart';
import 'package:app/View/Widget/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../Model/notifycation_model.dart';

class NotificationsService {
  static const key =
      'AAAAAKpsdlA:APA91bGZHUQVu0A-Ic6jUu9BiOHYv5sLwDfTSsdBae0dynB2x3YVO34gmcpHg4jGeF1ZWSU0ikc8geXL1ZsKIA6kIxc9gWLE_lS43FoTxQo7D3r6acyt_BhsPxVZdFxlN1Jpkd63_60O';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);

      const initializationSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint(details.payload.toString());
        },
      );
    } catch (e) {
      debugPrint('=======================chết ở 1');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final body = message.notification!.body;
      final title = message.notification!.title;

      final styleInformation = BigTextStyleInformation(
        body is String ? body : '',
        htmlFormatBigText: true,
        contentTitle: title is String ? title : '',
        htmlFormatTitle: true,
      );
      final androidDetails = AndroidNotificationDetails(
          'com.example.app_toptop.urgent', 'mychannelid',
          importance: Importance.max,
          styleInformation: styleInformation,
          priority: Priority.max);

      const iosDetails =
          DarwinNotificationDetails(presentAlert: true, presentBadge: true);

      final notificaltionDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificaltionDetails,
          payload: message.data['body']);
    } catch (e) {
      debugPrint('=======================chết ở 2');
    }
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('============================User granted permission');
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint(
          '============================User granted provisional permission');
      debugPrint('User granted provisional permission');
    } else {
      debugPrint(
          '============================User declined or has not accepted permission');
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print('===================================$token');
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  Future<String> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .get();
    return await getToken.data()!['token'];
  }

  void firebaseNotification(context) {
    try {
      _initLocalNotification();

      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const Bottom_Navigation_Bar(),
          ),
        );
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        await _showLocalNotification(message);
      });
    } catch (e) {
      debugPrint('===========================chết ở 4');
    }
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String idOther,
      required EnumNotificationType typeNotification}) async {
    String token = await getReceiverToken(idOther);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": token,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': uid,
          }
        }),
      )
          .then(
        (value) {
          createNotification(
            uid,
            idOther,
            toStringNotificationEnum(typeNotification),
          );
        },
      );
      // .onError(
      //   (error, stackTrace) =>
      //       debugPrint('đây là thất bại==============${error.toString()}'),
      // );
      debugPrint('thành công=======================');
    } catch (e) {
      debugPrint('Lỗi ==========================');
      debugPrint(e.toString());
    }
  }

  Stream<QuerySnapshot> getNotification() {
    try {
      final stream = FirebaseFirestore.instance
          .collection("Notifications")
          .orderBy('timestamp',
              descending:
                  true) // Sắp xếp theo trường timestamp, giảm dần (gần nhất đầu tiên)
          .snapshots();

      return stream;
    } catch (e) {
      print('Lỗi: $e');
      rethrow;
    }
  }

  void createNotification(String uid, String idOther, String type) async {
    final CollectionReference notifiCollection =
        FirebaseFirestore.instance.collection('Notifications');
    try {
      await notifiCollection.add(NotificationModel(
              id: '',
              uid: uid,
              idOther: idOther,
              type: type,
              timestamp: Timestamp.now())
          .toJson());
    } catch (e) {
      print(e);
    }
  }
}
