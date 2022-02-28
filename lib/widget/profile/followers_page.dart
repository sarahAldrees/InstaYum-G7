import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/search_users.dart';

class FollowersPage extends StatelessWidget {
  FollowersPage({Key? key, this.isFollowing = false, this.users = const []})
      : super(key: key);
  bool isFollowing;
  List<DocumentSnapshot> users;

  @override
  Widget build(BuildContext context) {
    List<UserModel> _list = users
        .map((u) => UserModel.fromJson(u.data() as Map<String, dynamic>))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("${isFollowing == true ? 'Followings' : 'Followers'}"),
      ),
      body: Container(
        child: SearchUsers(
          users: _list,
          isFollowing: isFollowing,
        ),
      ),
    );
  }
}
