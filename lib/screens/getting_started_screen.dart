import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as console show log;

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/getting-started-bg.jpeg"),
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                  width: double.infinity,
                  onPressed: _onTapLogin,
                  btnTitle: "Login",
                  bgColor: Theme.of(context).colorScheme.primary,
                  fgColor: Colors.white,
                  height: 50),
              const SizedBox(
                height: 11,
              ),
              CustomButton(
                  width: double.infinity,
                  onPressed: _onCreateNewAccount,
                  btnTitle: "Create New Account",
                  bgColor: Colors.grey.withOpacity(0.25),
                  fgColor: Colors.white,
                  height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _onCreateNewAccount() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
}
