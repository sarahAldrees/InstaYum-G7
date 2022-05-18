import 'package:instayum/constant/app_globals.dart';

class UserModel {
  String? imageUrl;
  String? pushToken;
  String? userId;
  String? username;
  bool? isFollowed;

  UserModel({
    this.imageUrl,
    this.pushToken,
    this.userId,
    this.username,
    this.isFollowed = false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    pushToken = json['pushToken'];
    userId = json['userId'];
    username = json['username'];
    isFollowed = json['isFollowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['image_url'] = this.imageUrl;
    data['pushToken'] = this.pushToken;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['isFollowed'] = this.isFollowed;
    return data;
  }

  UserModel getCurrentUserData() {
    UserModel currentUser = UserModel(
      userId: AppGlobals.userId,
      username: AppGlobals.userName,
      imageUrl: AppGlobals.userImage,
      pushToken: AppGlobals.pushToken,
    );

    return currentUser;
  }
}
