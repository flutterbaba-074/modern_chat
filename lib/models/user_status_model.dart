

import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusModel {
  final String statusImage;
  final String userName;
  final String uid;
  final String statusTime;

  UserStatusModel(
      {required this.statusTime,
      required this.uid,
      required this.statusImage,
      required this.userName});

  Map<String, dynamic> toMap() => {
        "statusImage": statusImage,
        "userName": userName,
        "uid": uid,
        "statusTime": statusTime,
      };

  factory UserStatusModel.fromMap(Map<String, dynamic> data) {
    return UserStatusModel(
      statusTime: data["statusTime"],
      uid: data["uid"],
      statusImage: data["statusImage"],
      userName: data["userName"],
    );
  }
}
