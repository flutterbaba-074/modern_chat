import 'package:chat_app/models/user_status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatusService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addStatus(UserStatusModel userStatus) async {
    String senderId = _auth.currentUser!.uid;

    await _firebaseFirestore.collection("status").doc(senderId).set(
          userStatus.toMap(),
          SetOptions(merge: true),
        );
  }
}
