import 'dart:collection';
import 'dart:developer' as console show log;
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {

 final FirebaseAuth _auth = FirebaseAuth.instance;
 
final List<UserModel> _userData = [];

UnmodifiableListView<UserModel> get userdData => UnmodifiableListView(_userData);

int get length => userdData.length;

Stream<QuerySnapshot<Map<String,dynamic>>> getAllUsers() 
 {
    

    return FirebaseFirestore.instance.collection("users").snapshots();

    

    
   

   

 }



 
  

}