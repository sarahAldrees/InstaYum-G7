import 'package:instayum/constant/app_globals.dart';

class UserModel {
  String? email;
  // String? fullName;
  String? imageUrl;
  String? pushToken;
  String? userId;
  String? username;
  bool? isFollowed;

  UserModel({
    this.email,
    // this.fullName,
    this.imageUrl,
    this.pushToken,
    this.userId,
    this.username,
    this.isFollowed = false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    // fullName = json['fullName'];
    imageUrl = json['image_url'];
    pushToken = json['pushToken'];
    userId = json['userId'];
    username = json['username'];
    isFollowed = json['isFollowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['email'] = this.email;
    // data['fullName'] = this.fullName;
    data['image_url'] = this.imageUrl;
    data['pushToken'] = this.pushToken;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['isFollowed'] = this.isFollowed;
    return data;
  }

  UserModel getCurrentUserData() {
    UserModel currentUser = UserModel(
      email: AppGlobals.email,
      userId: AppGlobals.userId,
      username: AppGlobals.userName,
      // fullName: AppGlobals.fullName,
      imageUrl: AppGlobals.userImage,
      pushToken: AppGlobals.pushToken,
    );

    return currentUser;
  }
}
