import 'package:chat_app/main.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as console show log;

import 'package:flutter/material.dart';

class NotificationService {
  static final _fireBaseMessaging = FirebaseMessaging.instance;

  static Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    var messageData = NotificationData.fromMap(message.data);

    console.log(message.data.toString());
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ChatScreen(
            recieverId: messageData.recieverId,
            recieverUserName: messageData.recieverUserName,
            token: messageData.token)));
  }

  static Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(

      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  static Future<void> initNotifications() async {
    await _fireBaseMessaging.requestPermission();
    var fcmToken = await _fireBaseMessaging.getToken();
    console.log(fcmToken.toString());
    initPushNotification();
  }
}
