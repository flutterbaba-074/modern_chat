import 'package:chat_app/screens/getting_started_screen.dart';
import 'package:chat_app/screens/chat_list_screen.dart';
import 'package:chat_app/screens/navigation_bar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const NavigationBarScreen();
          } else {
            return const GettingStartedScreen();
          }
        },
      ),
    );
  }
}
