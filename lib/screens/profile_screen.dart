import 'dart:io';
import 'dart:developer' as console show log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/ui_helper/ui_helper.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  String imageUrl = "";
  bool isImageLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isEditClicked = false;
  String userImage = "";
  String username = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _usernameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontFamily: "poppins",
                color: Theme.of(context).colorScheme.onBackground),
          ),
          actions: [
            IconButton(
                onPressed: isEditClicked ? _onTapSave : _onTapEdit,
                icon: Icon(
                  isEditClicked ? Icons.done : Icons.edit,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 30,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: _profileScreenBody());
  }

  Widget _profileScreenBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(
                  fontFamily: "poppins",
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }

        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> document =
              snapshot.data!.docs.where((element) {
            return element["uid"] == _auth.currentUser!.uid;
          }).toList();
          return _profileContent(document[0]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _profileContent(QueryDocumentSnapshot document) {
    var user = UserModel.fromMap(document.data() as Map<String, dynamic>);

    _usernameController.text = user.username;
    _bioController.text = user.bio;
    userImage = user.profileImage;
    var profileUrl = imageUrl.isEmpty
        ? userImage.isEmpty
            ? "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg"
            : userImage
        : imageUrl;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(

                onLongPress: () {
                  UiHelper.customImageDialog(context, profileUrl);
                },
                onTap: isEditClicked ? _onTapProfileImage : () {},
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CachedNetworkImage(
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: imageProvider,
                        );
                      },
                      imageUrl: profileUrl,
                      placeholder: (context, url) {
                        return Shimmer(
                          gradient: SweepGradient(
                              colors: [Colors.grey, Colors.grey.shade100]),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.withOpacity(0.4),
                          ),
                        );
                      },
                      height: 100,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      child: const Icon(Icons.brush),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Enter Username",
              style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              isPrefixVisible: true,
              maxLines: 1,
              isEnabled: isEditClicked,
              controller: _usernameController,
              prefixIcon: Icons.person,
              suffixIcon: Icons.done,
              hintText: "Choose Your Username",
              isSuffixIconVisible: false,
              keyboardType: TextInputType.name,
              obscureText: false,
              onSufficIconPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Enter Bio",
              style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              isPrefixVisible: false,
              maxLines: 5,
              isEnabled: isEditClicked,
              controller: _bioController,
              prefixIcon: Icons.edit,
              suffixIcon: Icons.done,
              hintText: "Enter Bio here.",
              isSuffixIconVisible: false,
              keyboardType: TextInputType.name,
              obscureText: false,
              onSufficIconPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedUserName = _usernameController.text.toString();
    console.log(selectedUserName);
    if (imageUrl.isEmpty) {
      var collectionData = await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
      var userData =
          UserModel.fromMap(collectionData.data() as Map<String, dynamic>);
      imageUrl = userData.profileImage;
    }
    await _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({
      "username": selectedUserName,
      "profileImage": imageUrl,
      "bio": _bioController.text.toString()
    }).then((value) {
      isEditClicked = false;
      setState(() {});
      EasyLoading.showToast(
        "Profile Updated Successfully",
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      prefs.setString("username", selectedUserName);
    }).onError((error, stackTrace) {
      EasyLoading.showToast("$error",
          toastPosition: EasyLoadingToastPosition.bottom);
    });
  }

  void _onTapEdit() {
    setState(() {
      isEditClicked = true;
    });
  }

  

  void _onTapProfileImage() {
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

  void _pickAndUploadImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file == null) return;
    if (!mounted) return;
    Navigator.pop(context);
    setState(() {
      isImageLoading = true;
    });

    Reference firebaseStorageRef = FirebaseStorage.instance.ref();
    Reference firebaseDirRef = firebaseStorageRef.child("images");
    Reference firebaseImage = firebaseDirRef.child(file.name);

    try {
      await firebaseImage.putFile(File(file.path));

      imageUrl = await firebaseImage.getDownloadURL();
      setState(() {
        isImageLoading = false;
      });
    } catch (error) {
      EasyLoading.showToast("$error",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}
