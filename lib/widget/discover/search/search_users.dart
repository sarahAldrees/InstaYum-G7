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
                            title: Column(
                              children: [
                                Text(
                                  'Are you sure to unfollow ?',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 30,
                                          left: 30,
                                          bottom: 0),
                                      child: Column(
                                        children: [
                                          TextButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 60,
                                                      vertical: 5),
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFFeb6d44),
                                              //side: BorderSide(color: Colors.deepOrange, width: 1),
                                              elevation: 0,
                                              //minimumSize: Size(100, 50),
                                              //shadowColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              _unFollowUser(uid, index, true);

                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFeb6d44),
                                              backgroundColor: Colors.white,
                                              //side: BorderSide(color: Colors.deepOrange, width: 1),
                                              elevation: 0,
                                              //minimumSize: Size(100, 50),
                                              //shadowColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )))
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
                              title: Column(
                                children: [
                                  Text(
                                    'Are you sure to unfollow ?',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              actions: [
                                Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            right: 30,
                                            left: 30,
                                            bottom: 0),
                                        child: Column(
                                          children: [
                                            TextButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 60,
                                                        vertical: 5),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFeb6d44),
                                                //side: BorderSide(color: Colors.deepOrange, width: 1),
                                                elevation: 0,
                                                //minimumSize: Size(100, 50),
                                                //shadowColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                _unFollowUser(
                                                    uid, index, false);
                                                widget.users[index].isFollowed =
                                                    false;

                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Color(0xFFeb6d44),
                                                backgroundColor: Colors.white,
                                                //side: BorderSide(color: Colors.deepOrange, width: 1),
                                                elevation: 0,
                                                //minimumSize: Size(100, 50),
                                                //shadowColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )))
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
