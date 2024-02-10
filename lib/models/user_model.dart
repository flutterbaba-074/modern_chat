class UserModel {
  final String uid;
  final String email;
  final String username;
  final String token;
  final String profileImage;
  final String bio;
  UserModel( 
      {required this.bio,
      required this.profileImage,
      required this.token,
      required this.username,
      required this.uid,
      required this.email});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        bio: data["bio"],
        uid: data["uid"],
        email: data["email"],
        username: data["username"],
        token: data["token"],
        profileImage: data["profileImage"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "bio": bio,
      "uid": uid,
      "email": email,
      "username":username,
      "token": token,
      "profileImage": profileImage
    };
  }
}
