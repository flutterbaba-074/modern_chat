import 'package:chat_app/models/user_model.dart';

class LastMessageModel {
  final UserModel user;
  final String? timeStamp;

  LastMessageModel({required this.user, required this.timeStamp});
}
