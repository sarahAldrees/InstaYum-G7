import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/follow_and_notification/follow_user_service.dart';
import 'package:instayum/widget/profile/user_profile_view.dart';

import '../../follow_and_notification/follow_tile.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({Key? key, this.users = const [], this.isFollowing = false})
      : super(key: key);
  final List<UserModel> users;
  final isFollowing;

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
                      widget.isFollowing == true
                          ? 'Unfollow'
                          : user.isFollowed == true
                              ? 'Unfollow'
                              : 'Follow',
                  followTap: () async {
                    if (widget.isFollowing == true) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            title: Text(
                              'Unfollow cooking enthusiast ',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Theme.of(context).accentColor),
                            ),
                            content: Text(
                              'Are you sure to unfollow?',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              RaisedButton(
                                color: Color(0xFFeb6d44),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _unFollowUser(uid, index, true);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      if (usersList[index].isFollowed == true) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              title: Text(
                                'Unfollow cooking enthusiast ',
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Theme.of(context).accentColor),
                              ),
                              content: Text(
                                'Are you sure to unfollow?',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                RaisedButton(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                RaisedButton(
                                  color: Color(0xFFeb6d44),
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    _unFollowUser(uid, index, false);
                                    widget.users[index].isFollowed = false;

                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        //----------Add user in globals following list----------
                        bool exist = AppGlobals.allFollowing.contains(uid);
                        if (!exist) AppGlobals.allFollowing.add(uid);

                        setState(() {
                          widget.users[index].isFollowed = true;
                        });
                        //-------------to adding user to followers list----------------
                        await followUserService.followUser(
                          context,
                          followId: uid,
                        );
                      }
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
        : Center(child: Text('No Results Found!'));
  }

  Future _unFollowUser(String? userid, int index, bool isRemove) async {
    followUserService.unFollowUser(context, followId: userid);
    bool exist = AppGlobals.allFollowing.contains(userid);
    if (exist) AppGlobals.allFollowing.remove(userid);

    if (isRemove) widget.users.removeAt(index);
    setState(() {});
  }
}
