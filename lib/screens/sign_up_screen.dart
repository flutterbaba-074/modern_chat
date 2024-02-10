import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/user_model.dart';
import 'dart:developer' as console show log;
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/navigation_bar_screen.dart';
import 'package:chat_app/services/auth/otp_service.dart';
import 'package:chat_app/ui_helper/ui_helper.dart';
import 'package:chat_app/utils/constants/app_constants.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  bool isPasswordVisible = true;
  bool isRememberMe = false;
  bool isImageLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CrossFadeState _continueState = CrossFadeState.showFirst;
  CrossFadeState _signUpMethodState = CrossFadeState.showFirst;
  CrossFadeState _otpMethodState = CrossFadeState.showFirst;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
  }
  String otp = "";
  String imageUrl = "";
  double mHeight = 0;
  double mWidth = 0;
  
  @override
  Widget build(BuildContext context) {
    
    var mH = MediaQuery.sizeOf(context).height;
    var mW = MediaQuery.sizeOf(context).width;
    mHeight = mH;
    mWidth = mW;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/animations/chat-animation.json"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 20,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Please Sign up to Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
                    child: SingleChildScrollView(
                      child: AnimatedCrossFade(
                        sizeCurve: Curves.linear,
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                        crossFadeState: _continueState,
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onTap: _onTapProfile,
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          imageUrl.isEmpty
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: const AssetImage(
                                                      "assets/images/default-profile-image.jpeg"),
                                                  child: isImageLoading
                                                      ? const CircularProgressIndicator()
                                                      : const SizedBox(),
                                                )
                                              : CachedNetworkImage(
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          imageProvider,
                                                    );
                                                  },
                                                  imageUrl: imageUrl,
                                                  placeholder: (context, url) {
                                                    return Shimmer(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.grey,
                                                            Colors
                                                                .grey.shade100,
                                                          ]),
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.4),
                                                        child: const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  height: 100,
                                                ),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.6),
                                            child: const Icon(Icons.brush),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Enter Username",
                                    style: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  CustomTextField(
                                    isPrefixVisible: true,
                                    maxLines: 1,
                                    isEnabled: true,
                                    onSufficIconPressed: () {},
                                    obscureText: false,
                                    keyboardType: TextInputType.text,
                                    controller: _usernameController,
                                    prefixIcon: Icons.person,
                                    suffixIcon: Icons.arrow_right,
                                    hintText: "Enter a Username",
                                    isSuffixIconVisible: false,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: mH * .05,
                            ),
                            CustomButton(
                                width: double.infinity,
                                onPressed: () async {

                                  
                                  var username = _usernameController.text
                                      .trim()
                                      .toString();
                                  if (username.length > 5) {

                                    if (imageUrl.isEmpty) {
                                      UiHelper.showToast(
                                          "Please select profile pic");
                                    } else {
                                      UiHelper.showLoader();
                                      await isUserNameExist(username)
                                          .then((value) {
                                        if (value) {
                                          UiHelper.showToast(
                                              "Username Already Exist");
                                        } else {
                                          EasyLoading.dismiss();

                                          _onTapCrossfadeChange();
                                        }
                                      }).catchError((error) {
                                        UiHelper.showToast(error.toString());
                                      });
                                    }  


                                  } else {
                                    UiHelper.showToast(
                                        "Length must be greater than 5 characters");
                                  }
                                },
                                btnTitle: "Continue",
                                bgColor: Theme.of(context).colorScheme.primary,
                                fgColor: Colors.white,
                                height: 50),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: _onTapLogin,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        secondChild: AnimatedCrossFade(
                          sizeCurve: Curves.linear,
                          firstCurve: Curves.easeIn,
                          secondCurve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                          crossFadeState: _signUpMethodState,
                          firstChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enter Email",
                                      style: TextStyle(
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CustomTextField(
                                      isPrefixVisible: true,
                                      maxLines: 1,
                                      isEnabled: true,
                                      onSufficIconPressed: () {},
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      prefixIcon: Icons.mail,
                                      suffixIcon: Icons.arrow_right,
                                      hintText: "Enter Your Email",
                                      isSuffixIconVisible: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Enter Password",
                                      style: TextStyle(
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CustomTextField(
                                        isPrefixVisible: true,
                                        maxLines: 1,
                                        isEnabled: true,
                                        onSufficIconPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                        obscureText: isPasswordVisible,
                                        controller: _passwordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        prefixIcon: Icons.lock,
                                        suffixIcon: isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        hintText: "Enter Your Password",
                                        isSuffixIconVisible: true),
                                    const SizedBox(
                                      height: 11,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: mH * .05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  authenticationMethodWidget(
                                    onPressed: () {
                                      _signUpMethodState =
                                          CrossFadeState.showSecond;
                                      setState(() {});
                                    },
                                    icon: UniconsLine.phone,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  authenticationMethodWidget(
                                    onPressed: _onTapGoogleSignIn,
                                    icon: UniconsLine.google,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  authenticationMethodWidget(
                                    onPressed: _onTapFaceBookSignIn,
                                    icon: UniconsLine.facebook,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButton(
                                          width: double.infinity,
                                          onPressed: _onTapCrossfadeChange,
                                          btnTitle: "Back",
                                          bgColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.8),
                                          fgColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          height: 50)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                        width: double.infinity,
                                        onPressed: _onTapSignUp,
                                        btnTitle: "Sign Up",
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fgColor: Colors.white,
                                        height: 50),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: _onTapLogin,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          secondChild: phoneAuthenticationWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 

  Future<bool> isUserAlreadyExist(String uid) async {
    final querySnapshot =
        await _firestore.collection("users").where("uid", isEqualTo: uid).get();

    return querySnapshot.docs.isNotEmpty;
  } 

  Future<bool> isUserNameExist(String username) async {
    final querysnapshot = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();

    return querysnapshot.docs.isNotEmpty;
  }
  _onTapFaceBookSignIn() async {
    // trigger the flow
    LoginResult loginResult = await FacebookAuth.instance.login();
    // obtain the user
    OAuthCredential credential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    var token = await FirebaseMessaging.instance.getToken();

    UiHelper.showLoader();


    try {
      await _auth.signInWithCredential(credential).then((value) async {
        final isUserExist = await isUserAlreadyExist(value.user!.uid);
        UserModel user;
        if (isUserExist) {
          var userSnapshot =
              await _firestore.collection("users").doc(value.user!.uid).get();

          user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        } else {
          user = UserModel(
          bio: "",
          profileImage: imageUrl,
          token: token!,
          username: _usernameController.text.toString(),
          uid: value.user!.uid,
          email: value.user!.email ?? "",
        );
        }

        _firestore.collection("users").doc(user.uid).set(
              user.toMap(),
              SetOptions(merge: true),
            );
        UiHelper.showToast("Account Created SuccessFully");
        _setUserPref(token!);
        _navigateToHomePage();
      });
    } catch (e) {
      console.log(e.toString());
      UiHelper.showToast(e.toString());
    }
  }

  Widget authenticationMethodWidget(
      {required VoidCallback onPressed, required IconData icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        child: Icon(icon),
      ),
    );
  }

  Widget phoneAuthenticationWidget() {
    return AnimatedCrossFade(
        sizeCurve: Curves.linear,
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
        crossFadeState: _otpMethodState,
        firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Phone Number",
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
                    isEnabled: true,
                    onSufficIconPressed: () {},
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    prefixIcon: Icons.mail,
                    suffixIcon: Icons.arrow_right,
                    hintText: "Enter Your Phone Number",
                    isSuffixIconVisible: false,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mHeight * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                authenticationMethodWidget(
                  onPressed: () {
                    _signUpMethodState = CrossFadeState.showFirst;
                    setState(() {});
                  },
                  icon: Icons.mail,
                ),
                const SizedBox(
                  width: 10,
                ),
                authenticationMethodWidget(
                  onPressed: _onTapGoogleSignIn,
                  icon: UniconsLine.google,
                )
              ],
            ),
            const SizedBox(
              height: 11,
            ),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        width: double.infinity,
                        onPressed: () {
                          _signUpMethodState = CrossFadeState.showFirst;
                          setState(() {});
                        },
                        btnTitle: "Back",
                        bgColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                        fgColor: Theme.of(context).colorScheme.onPrimary,
                        height: 50)),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                      width: double.infinity,
                      onPressed: () async {
                        var phoneNumber =
                            _phoneController.text.trim().toString();
                        if (phoneNumber.isNotEmpty) {
                          if (phoneNumber.length == 10) {
                            //otp work
                            UiHelper.showLoader();
                            try {
                              await context
                                  .read<OtpService>()
                                  .generateOtp(phoneNumber: "+91$phoneNumber")
                                  .then((value) {
                            _otpMethodState = CrossFadeState.showSecond;
                            
                                UiHelper.showToast("otp sent SuccessFully");
                            setState(() {});

                              });
                            } catch (e) {
                              UiHelper.showToast(
                                e.toString(),
                              );
                            }
 
                          } else {
                            UiHelper.showToast(
                                "Length must be 10 digits longer");
                          }
                        } else {
                          UiHelper.showToast("Please Enter the Phone Number");
                        }
                      },
                      btnTitle: "Continue",
                      bgColor: Theme.of(context).colorScheme.primary,
                      fgColor: Colors.white,
                      height: 50),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _onTapLogin,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        secondChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Otp",
                    style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    length: 6,
                    onChanged: (value) {
                      otp = value;
                      // console.log(otp);
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: mHeight * .05,
            ),
            Row(
              children: [
                Expanded(
                    child: CustomButton(
                        width: double.infinity,
                        onPressed: () {
                          _otpMethodState = CrossFadeState.showFirst;
                          setState(() {});
                        },
                        btnTitle: "Back",
                        bgColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                        fgColor: Theme.of(context).colorScheme.onPrimary,
                        height: 50)),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                      width: double.infinity,
                      onPressed: () {
                       
                        if (otp.isNotEmpty) {
                          if (otp.length == 6) {
                            _onTapPhoneSignUp();
                          } else {
                            UiHelper.showToast(
                                "Length must be 6 digits longer");
                          }
                        } else {
                          UiHelper.showToast("Please Enter The Otp");
                        }
                      },
                      btnTitle: "Verify",
                      bgColor: Theme.of(context).colorScheme.primary,
                      fgColor: Colors.white,
                      height: 50),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _onTapLogin,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  _onTapPhoneSignUp() async {
    var token = await FirebaseMessaging.instance.getToken();
    UiHelper.showLoader();
    if (!mounted) return;

    try {
      await context
          .read<OtpService>()
          .authenticateUser(otp: otp, verficationId: gVerficationId)
          .then((value) async {
        var userExist =
            await context.read<OtpService>().isUserExist(uid: value.user!.uid);

        if (userExist) {
          UiHelper.showToast("User Exist");
        } else {
          var user = UserModel(
            bio: "",
            profileImage: imageUrl,
            token: token!,
            username: _usernameController.text.toString(),
            uid: value.user!.uid,
            email: _phoneController.text.toString(),
          );

          _firestore.collection("users").doc(value.user!.uid).set(
                user.toMap(),
                SetOptions(merge: true),
              );

          _setUserPref(token);
          _navigateToHomePage();
        }
      });
    } catch (e) {
      UiHelper.showToast(e.toString());
    }
  }

  _onTapGoogleSignIn() async {
 
    //  trigger the flow
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //obtain the user
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final userCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    
    
    var token = await FirebaseMessaging.instance.getToken();

    UiHelper.showLoader();
    try {
      await _auth.signInWithCredential(userCredential).then((value) async {
        final isUserExist = await isUserAlreadyExist(value.user!.uid);
        UserModel user;
        if (isUserExist) {
          final userSnapshot =
              await _firestore.collection("users").doc(value.user!.uid).get();
          user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        } else {
          user = UserModel(
            bio: "",
            profileImage: imageUrl,
            token: token!,
            username: _usernameController.text.trim().toString(),
            uid: value.user!.uid,
            email: value.user!.email!);
        }



        _firestore.collection("users").doc(user.uid).set(
              user.toMap(),
              SetOptions(merge: true),
            );
        UiHelper.showToast("Account Created Successfully");
        _setUserPref(token!);
        _navigateToHomePage();
      });
    } catch (e) {
      UiHelper.showToast(e.toString());
    }
  }

 

  _onTapProfile() {


    _customModalBottomSheet();
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
                          isImageLoading = true;
                          setState(() {});
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
                          isImageLoading = true;
                          setState(() {});
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
    
     
    Reference firebaseStorage = FirebaseStorage.instance.ref();
    Reference firebaseImageDir = firebaseStorage.child("Images");
    Reference firebaseImageName = firebaseImageDir.child(file.name);

    try {
      await firebaseImageName.putFile(File(file.path));

      imageUrl = await firebaseImageName.getDownloadURL();
      setState(() {
        isImageLoading = false;
      });
     

      console.log(imageUrl);
    } catch (error) {
     
      UiHelper.showToast(error.toString());
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

  _onTapCrossfadeChange() {
    setState(() {
      if (_continueState == CrossFadeState.showFirst) {
        _continueState = CrossFadeState.showSecond;
      } else {
        _continueState = CrossFadeState.showFirst;
      }
    });
  }

  _onTapSignUp() async {
    var email = _emailController.text.trim().toString();
    var password = _passwordController.text.trim().toString();

    if (email.isNotEmpty && password.isNotEmpty) {
      UiHelper.showLoader();
      // var authService = Provider.of<AuthService>(context, listen: false);
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          var token = await FirebaseMessaging.instance.getToken();
          if (imageUrl.isEmpty) {
            imageUrl =
                "https://cdn.vectorstock.com/i/preview-1x/17/61/male-avatar-profile-picture-vector-10211761.jpg";
          }
          var user = UserModel(
              bio: "",
              profileImage: imageUrl,
              token: token!,
              uid: value.user!.uid,
              email: value.user!.email!,
              username: _usernameController.text.trim.toString());
          _firestore
              .collection('users')
              .doc(user.uid)
              .set(user.toMap(), SetOptions(merge: true));

          UiHelper.showToast("Account Created Successfully");
          _setUserPref(token);
          _navigateToHomePage();
        });
      } catch (e) {
        UiHelper.showToast(e.toString());
      }
    } else {
      UiHelper.showToast("Please Enter the Details");
    }
  }

  

  

  _navigateToHomePage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
  }

  _setUserPref(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", _usernameController.text.toString());
    prefs.setString("profileImage", imageUrl);
    prefs.setString("token", token);
  }

  _onTapLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
