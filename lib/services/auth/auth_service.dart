import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in User
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

//  sign out User
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  // Future<UserCredential> signUpWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);

  //     var user =
  //         UserModel(uid: credential.user!.uid, email: credential.user!.email!);
  //     _firestore
  //         .collection("users")
  //         .doc(credential.user!.uid)
  //         .set(user.toMap());
  //     return credential;
  //   } on FirebaseAuthMultiFactorException catch (e) {
  //     throw Exception(e.code);
  //   }
  // }
}
