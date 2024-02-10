import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.message});
final RemoteMessage message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message.notification?.title ?? "N/A"),
            Text(message.notification?.body ?? "N/A"),
            // Text(message.notification? ?? "N/A"),
          ],
        ),
      ),
    );
  }
}