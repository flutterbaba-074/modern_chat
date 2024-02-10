import 'package:chat_app/controllers/user_data_provider.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/otp_service.dart';
import 'package:chat_app/services/chat_services/chat_service.dart';
import 'package:chat_app/services/notification_services/notification_service.dart';
import 'package:chat_app/services/status_services/status_services.dart';
import 'package:chat_app/utils/themes/themes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await NotificationService.initNotifications();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthService()
      ),
      ChangeNotifierProvider(create: (context) => ChatService()),
      ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ChangeNotifierProvider(create: (context) => StatusService()),
      ChangeNotifierProvider(create: (context) => OtpService())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: EasyLoading.init(),
    );
  }
}
