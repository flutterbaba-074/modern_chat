import 'dart:developer' as console show log;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/api_services.dart';
import 'package:chat_app/services/chat_services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.recieverId,
      required this.recieverUserName,
      required this.token});
  final String recieverId;
  final String token;
  final String recieverUserName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _messageController;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageController = TextEditingController();
    msgsSeen();
  }

  void msgsSeen() async {
    String senderId = _auth.currentUser!.uid;
    String chatRoomId = context
        .read<ChatService>()
        .getChatRoomId(recieverId: widget.recieverId, senderId: senderId);
    final querySnapShot = await _firebaseFirestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .where("recieverId", isEqualTo: senderId)
        .get();

    for (final doc in querySnapShot.docs) {
      await _firebaseFirestore
          .collection("chat_room")
          .doc(chatRoomId)
          .collection("messages")
          .doc(doc.id)
          .update({"isSeen": 1});

}
isAlreadyUpdated = true;
  }

  bool isAlreadyUpdated = false;
 
  String imageUrl = "";
  bool isImageSelected = false;
  bool isImageLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _messageController.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    if (!isAlreadyUpdated) {
      msgsSeen();
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          widget.recieverUserName,
          style: TextStyle(
            fontFamily: "poppins",
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/chat-bg-img.jpeg"))),
        child: chatScreenBody(context),
      ),
    );
  }

  Widget chatScreenBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: chatMessageWidget(context)),
        chatInputWidget()
      ],
    );
  }

  Widget chatMessageWidget(BuildContext context) {
    var chatService =
        context.read<ChatService>().getMessages(widget.recieverId);

    return StreamBuilder<QuerySnapshot>(
      stream: chatService,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return ListView(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              dragStartBehavior: DragStartBehavior.down,
              shrinkWrap: true,

              // shrinkWrap: true,
              // reverse: trueSS,

              children: snapshot.data!.docs
                  .map((doc) => GestureDetector(
                      onTap: () {
                        console.log(doc["senderId"]);
                        console.log(doc["recieverId"]);
                        console.log(_auth.currentUser!.uid);
                        if (doc["senderId"] == _auth.currentUser!.uid) {
                          context
                              .read<ChatService>()
                              .deleteMessage(_auth.currentUser!.uid);
                        }
                      },
                      child: chatMessageItemWidget(doc)))
                  .toList());
        }

        return const SizedBox();
      },
    );
  }

  Widget chatMessageItemWidget(DocumentSnapshot document) {
    var chatMessage =
        ChatMessageModel.fromMap(document.data() as Map<String, dynamic>);
    bool isSendedByMe = chatMessage.senderId == _auth.currentUser!.uid;

    bool isImage = chatMessage.fileType == 0;
    return Container(
      alignment: isSendedByMe ? Alignment.bottomRight : Alignment.bottomLeft,
      margin: const EdgeInsets.only(bottom: 11, top: 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * .5,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isSendedByMe ? 20 : 0),
                    right: Radius.circular(isSendedByMe ? 0 : 20))),
            padding: EdgeInsets.fromLTRB(
              isImage ? 0 : 30,
              isImage ? 0 : 11,
              isImage ? 0 : 20,
              isImage ? 0 : 11,
            ),
            child: isImage
                ? CachedNetworkImage(
                    imageUrl: chatMessage.message,
                    placeholder: (context, url) {
                      return Shimmer(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey,
                              Colors.grey.shade100,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          child: const SizedBox(
                            height: 200,
                            width: 200,
                          ));
                    },
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                        ),
                      );
                    },
                  )
                : Text(
                    chatMessage.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget chatInputWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(26)),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          isImageSelected
              ? Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) {
                          return Shimmer(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.grey.shade100,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                          );
                        },
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isImageSelected = false;
                            });
                          },
                          child: const CircleAvatar(
                            // backgroundColor: Colors.grey.withOpacity(0.3),
                            child: Icon(Icons.cancel),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Row(
            children: [
              const SizedBox(
                width: 11,
              ),
              Icon(
                Icons.emoji_emotions,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 11,
              ),
              SpeedDial(
                animatedIcon: isImageLoading ? null : AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                children: [
                  SpeedDialChild(
                    onTap: _customModalBottomSheet,
                    shape: const CircleBorder(),
                    // labelWidget: Container(
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.background,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   padding: const EdgeInsets.all(5),
                    //   child: Text(
                    //     "Image",
                    //     style: TextStyle(
                    //         color: Theme.of(context).colorScheme.onBackground),
                    //   ),
                    // ),
                    child: const Icon(
                      Icons.image,
                    ),
                  )
                ],
                child: isImageLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Icon(
                        Icons.attach_file,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              Expanded(
                child: TextField(
                  enabled: !isImageSelected,
                  controller: _messageController,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
                ),
              ),
              InkWell(
                onTap: () {
                  _onTapSend();
                },
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(
                width: 11,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _customModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 100,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Choose the Option",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _customMenuItem(
                        icon: Icons.camera,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)),
                        onPressed: () {
                          _pickAndUploadImage(ImageSource.camera);
                        }),
                    const SizedBox(
                      width: 1,
                    ),
                    _customMenuItem(
                        icon: Icons.image,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10)),
                        onPressed: () {
                          _pickAndUploadImage(ImageSource.gallery);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _pickAndUploadImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    console.log("We are almost there");
    XFile? file = await imagePicker.pickImage(source: imageSource);
    if (file == null) return;

    if (!mounted) return;
    Navigator.pop(context);

    setState(() {});
    Reference firebaseStorage = FirebaseStorage.instance.ref();
    Reference firebaseImageDir = firebaseStorage.child("Images");
    Reference firebaseImageName = firebaseImageDir.child(file.name);

    try {
      setState(() {
        isImageLoading = true;
      });
      await firebaseImageName.putFile(File(file.path));

      imageUrl = await firebaseImageName.getDownloadURL();
      setState(() {
        isImageLoading = false;
        isImageSelected = true;
      });

      console.log(imageUrl);
    } catch (error) {
      EasyLoading.showToast("$error",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Widget _customMenuItem(
      {required VoidCallback onPressed,
      required IconData icon,
      required BorderRadius borderRadius}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 50,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }

  void _onTapSend() async {
    var message =
        isImageSelected ? imageUrl : _messageController.text.trim().toString();
    if (message.isNotEmpty) {
      _messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      context
          .read<ChatService>()
          .sendMessage(
            widget.recieverId,
            message,
            isImageSelected ? 0 : 1,
          )
          .then((value) async {
        if (isImageSelected) {
          isImageSelected = false;
          setState(() {});
        }

        console.log(widget.recieverId);
        console.log(_auth.currentUser!.uid);

        DocumentSnapshot<Map<String, dynamic>> document =
            await _firebaseFirestore
                .collection("users")
                .doc(_auth.currentUser!.uid)
                .get();
        var userData =
            UserModel.fromMap(document.data() as Map<String, dynamic>);

        var notificationResult = await ApiService.sendMessage(
            notification: NotificationModel(
                token: widget.token,
                data: NotificationData(
                    recieverId: _auth.currentUser!.uid,
                    recieverUserName: userData.username,
                    token: widget.token),
                notification: NotificationBody(body: message)));

        if (notificationResult == 0) {
          EasyLoading.showToast("Failed to send Notification",
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      });
    }
  }
}
