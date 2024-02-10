import 'dart:async';

import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/last_message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as console show log;

 


class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
// send Message Function
  Future<void> sendMessage(
    String recieverId,
    String message,
    int fileType,
  ) async {
    //information of current user
    final String senderId = _auth.currentUser!.uid;
    final String senderEmail = _auth.currentUser!.email!;

    // chat instance
    var chatInstance = ChatMessageModel(
isSeen: 0,
        fileType: fileType,
        message: message,
        recieverId: recieverId,
        senderId: senderId,
        senderEmail: senderEmail,
        timeStamp: DateTime.now().toString());

//creating chat room id
   

    await _firestore
        .collection("chat_room")
        .doc(getChatRoomId(recieverId: recieverId, senderId: senderId))
        .collection("messages")
        .add(chatInstance.toMap());
  }

  Future<void> deleteMessage(String recieverId) async {
    final String senderId = _auth.currentUser!.uid;

    List<String> dns = [recieverId, senderId];

    dns.sort();
    final String chatRoomId = dns.join("_");

    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .doc(senderId)
        .delete()
        .then((value) {
      print("Deleted SuccessFully");
    }, onError: (e) {
      print("$e");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String recieverId) {
    final String senderId = _auth.currentUser!.uid;
    // generating chat room id
   

   

    // returning snapshots of doc
    return _firestore
        .collection("chat_room")
        .doc(getChatRoomId(recieverId: recieverId, senderId: senderId))
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  String getChatRoomId({required String recieverId, required String senderId}) {
    List<String> dns = [recieverId, senderId];
    dns.sort();
    String chatRoomId = dns.join("_");

    return chatRoomId;
  }

  // Stream<List<ChatModel>> getChats() async* {
  //   final currentUser = _auth.currentUser!.uid;
  //   final users = await _firestore.collection("users").get();

  //   List<ChatModel> chatList = [];

  //   for (final element in users.docs) {
  //     var user = UserModel.fromMap(element.data());

  //     if (user.uid != currentUser) {
  //       final chatDetailSnapshot = await _firestore
  //           .collection("chat_room")
  //           .doc(getChatRoomId(
  //               recieverId: user.uid, senderId: _auth.currentUser!.uid))
  //           .collection("messages")
  //           .where(
  //             "recieverId",
  //             isEqualTo: _auth.currentUser!.uid,
  //           )
  //           .where("isSeen", isEqualTo: 0)
  //           .get();
  //       Map chatDetails;

  //       if (chatDetailSnapshot.docs.isEmpty) {
  //         chatDetails = {"message": "", "timeStamp": ""};
  //       } else {
  //         chatDetails = {
  //           "message": chatDetailSnapshot.docs.last.data()["message"],
  //           "timeStamp": chatDetailSnapshot.docs.last.data()["timeStamp"],
  //         };
  //       }

  //       chatList.add(ChatModel(
  //           uid: user.uid,
  //           lastMsg: chatDetails["message"],
  //           profileImage: user.profileImage,
  //           time: chatDetails["timeStamp"].toString(),
  //           token: user.token,
  //           unseenMsgCount: chatDetailSnapshot.docs.length,
  //           username: user.username));
  //     }
  //   }
  //   console.log(chatList.length.toString());

  //   yield chatList;
  // }



  

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String recieverId) {
    return _firestore
        .collection("chat_room")
        .doc(getChatRoomId(
            recieverId: recieverId, senderId: _auth.currentUser!.uid))
        .collection("messages")
        .where("recieverId", isEqualTo: _auth.currentUser!.uid)
        .where("isSeen", isEqualTo: 0)
        .snapshots();
  }


  Future<String?> getLastMessageTimestamp(String recieverId) async {
    var messageDetails = await _firestore
        .collection("chat_room")
        .doc(getChatRoomId(
            recieverId: recieverId, senderId: _auth.currentUser!.uid))
        .collection("messages")
        .where("recieverId", isEqualTo: _auth.currentUser!.uid)
        .where("isSeen", isEqualTo: 0)
        .get();

    if (messageDetails.docs.isEmpty) {
      return null;
    }

    var lastMessageDetails =
        ChatMessageModel.fromMap(messageDetails.docs.last.data());

    return lastMessageDetails.timeStamp;
  }

  

 
}
