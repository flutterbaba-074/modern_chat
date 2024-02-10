import 'dart:async';

import 'package:chat_app/screens/auth_gate.dart';
import 'package:chat_app/screens/getting_started_screen.dart';
import 'package:chat_app/screens/navigation_bar_screen.dart';
import 'package:chat_app/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    navigateToPage();
  }

  void navigateToPage() async {
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 4), () {
      
     String? token = prefs.getString("token") ;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => token==null?const GettingStartedScreen():const NavigationBarScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/chat-animation.json"),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppConstants.appName,
              style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}
