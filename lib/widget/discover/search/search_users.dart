import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/profile/user_profile_view.dart';

import 'follow_tile.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({
    Key? key,
    this.users = const [],
  }) : super(key: key);
  final List<UserModel> users;

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  List<String?> userIds = [];
  List<UserModel> usersList = [];

  fetchUsers() {
    userIds.clear();
    usersList.clear();
    List<UserModel> tempUsers = List.from(widget.users);

    if (tempUsers.isNotEmpty) {
      for (int index = 0; index < tempUsers.length; index++) {
        userIds.add(tempUsers[index].userId);
        usersList.add(tempUsers[index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchUsers();

    return usersList.length > 0
        ? ListView.builder(
            itemCount: usersList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              UserModel user = usersList[index];
              String? uid = usersList[index].userId;

              if (uid != AppGlobals.userId) {
                return FollowTile(
                  name: user.username,
                  userName: user.username,
                  userImage: user.imageUrl,
                  buttonText: "Follow",
                  //HERE YOU CAN ACTIVIATE THE BUTTON AND CHANGE IT FORM FOLLOW TO UNFOLLOW
                  userTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ccontext) => UserProfileView(userId: uid),
                        ));
                  },
                );
              } else {
                return Container();
              }
            },
          )
        : Center(child: Text('No results found!'));
  }
}
