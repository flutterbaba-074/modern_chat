import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/getting_started_screen.dart';
import 'package:chat_app/services/chat_services/chat_service.dart';
import 'package:chat_app/ui_helper/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {


  bool isImageLoading = false;
  void _signOutUser() async {
    // var authService = context.read<AuthService>();


    
    // authService.signOut();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut().then((value) {
        prefs.clear();  


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const GettingStartedScreen()));
      });
    } catch (e) {
      EasyLoading.showToast(
        "$e",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Chat-Buddy",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _signOutUser();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: userListWidget(),
    );
  }

  Widget userListWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return ListView(
            children:
                snapshot.data!.docs.map((doc) => listUserItem(doc)).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget listUserItem(DocumentSnapshot document) {
    var user = UserModel.fromMap(document.data() as Map<String, dynamic>);

   

   
    var profileUrl = user.profileImage.isEmpty
        ? "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"
        : user.profileImage;
    if (_auth.currentUser!.uid != user.uid) {
      return ListTile(
        onTap: () {
          _onTapChat(
            recieverUserName: user.username,
            recieverId: user.uid,
            token: user.token,
          );
        },
        leading: GestureDetector(
          onLongPress: () {
            UiHelper.customImageDialog(context, profileUrl);
          },
          child: CachedNetworkImage(
            imageUrl: profileUrl,
            height: 60,
            placeholder: (context, url) {
              return Shimmer(
                gradient: SweepGradient(
                  colors: [
                    Colors.grey,
                    Colors.grey.shade100,
                  ],
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
              );
            },
            maxHeightDiskCache: 60,
            maxWidthDiskCache: 60,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: 30,
                backgroundImage: imageProvider,
              );
            },
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        subtitle: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: context.read<ChatService>().getLastMessage(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = snapshot.data!.docs;

                return list.isEmpty
                    ? const SizedBox()
                    : Text(
                        list.last.data()["message"],
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: Theme.of(context).colorScheme.onBackground),
                      );
              } else {
                return const SizedBox();
              }
            }
        ),
        trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: context.read<ChatService>().getLastMessage(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = snapshot.data!.docs;
                return list.isEmpty
                    ? const SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(Jiffy.parse(list.last.data()["timeStamp"])
                              .format(pattern: "h:mm a")),
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Center(
                                child: Text(
                              list.length.toString(),
                              style: const TextStyle(fontSize: 10),
                            )),
                          ),
                        ],
                      );
              }
              return const SizedBox();
            }
        ),
        title: Text(user.username),
      );
    }
    return const SizedBox();
  }



  _onTapChat(
      {required String recieverId,
      required String recieverUserName,
      required String token}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                token: token,
                recieverId: recieverId,
                recieverUserName: recieverUserName)));
  }
}
