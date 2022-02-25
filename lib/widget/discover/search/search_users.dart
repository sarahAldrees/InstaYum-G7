import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/follow_and_notification/follow_user_service.dart';
import 'package:instayum/widget/profile/user_profile_view.dart';

import '../../follow_and_notification/follow_tile.dart';

class SearchUsers extends StatefulWidget {
  static bool isFollowing = false;
  SearchUsers({
    Key? key,
    this.users = const [],
  }) : super(key: key);
  final List<UserModel> users;

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  final FollowUserService followUserService = FollowUserService();
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
              if (AppGlobals.allFollowing.contains(uid)) {
                user.isFollowed = true;
              }

              if (uid != AppGlobals.userId) {
                return FollowTile(
                  name: user.username,
                  userName: user.username,
                  userImage: user.imageUrl,
                  buttonText:
                      //--------------show follow and in follow button------------
                      SearchUsers.isFollowing == true
                          ? 'Unfollow'
                          : user.isFollowed == true
                              ? 'Unfollow'
                              : 'Follow',
                  followTap: () async {
                    // print('UserId: $_userid ${AppGlobals.userId}');
                    if (SearchUsers.isFollowing == false) {
                      //----------Add user in globals following list----------
                      bool exist = AppGlobals.allFollowing.contains(uid);
                      if (!exist) AppGlobals.allFollowing.add(uid);

                      setState(() {
                        // user.isFollowed = true;
                        widget.users[index].isFollowed = true;
                      });
                      //-------------to adding user to followers list----------------
                      await followUserService.followUser(
                        context,
                        followId: uid,
                      );
                    }
                  },
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
