import 'package:chat_app/models/user_model.dart';
import 'dart:developer' as console show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

String gVerficationId = "";

class OtpService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _verficationId = "";
  String get verficationId => _verficationId;
  // static Future<void> generateOtp(){

  // }



  Future<void> generateOtp({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        console.log(
          error.message.toString(),
        );
        throw Exception(error.message);
      },
      codeSent: (verificationId, forceResendingToken) {
        console.log(verficationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> authenticateUser(
      {required String otp, required String verficationId}) async {
    PhoneAuthCredential userCredential = PhoneAuthProvider.credential(
        verificationId: verficationId, smsCode: otp);
    console.log(verficationId);

    return await _auth.signInWithCredential(userCredential);
  }

  Future<bool> isUserExist({required String uid}) async {
    var data = await _fireStore.collection("users").doc(uid).get();

    if (data.data() != null) {
      return true;
    } else {
      return false;
    }
  }

}
