class ChatModel {
  final String uid;
  final String username;
  final String token;
  final String profileImage;
  final String lastMsg;
  final int unseenMsgCount;
  final String time;

  ChatModel(
      {required this.uid,
      required this.lastMsg,
      required this.profileImage,
      required this.time,
      required this.token,
      required this.unseenMsgCount,
      required this.username});
}
