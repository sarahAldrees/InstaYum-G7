import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/search_users.dart';
import 'package:instayum/widget/follow_and_notification/follow_user_service.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/followers_numbers.dart';
import 'package:instayum/widget/recipe_view/my_recipes_screen.dart';

class UserProfileView extends StatefulWidget {
  final String? userId;
  UserProfileView({required this.userId});
  @override
  State<StatefulWidget> createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  // ---------------- Database -------------------------
  String? userUsername;
  String? imageURL;
  String? uId;
  bool isLoading = true;
  final FollowUserService followUserService = FollowUserService();
  bool isFollowed = false;
  late UserModel user;
//getData() to get the data of users like username, image_url from database
  void getData() async {
    if (widget.userId != null) {
      print('get User data ${widget.userId}');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get()
          .then((userData) {
        Map<String, dynamic> data = userData.data()!;
        user = UserModel.fromJson(data);
        // isFollow = user.isFollowed!;
        userUsername = user.username;
        imageURL = user.imageUrl;
        uId = userData.id;
        if (AppGlobals.allFollowing.contains(userData.id)) {
          user.isFollowed = true;
        }
        // print('userId: ' + AppGlobals.userId);
        return userData;
      });
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //we call the method here to get the data immediately when init the page.
    getData();
  }

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("${userUsername ?? ''} Profile"),
      ),
      body: isLoading
          ? CustomCircularLoader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      // show User image and username
                      buildImage(),

                      if (uId != null) FollowersNumbers(userId: uId),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 11),
                  //   child:
                  // ),
                  //-------------- follow button-----------
                  Container(
                    margin: const EdgeInsets.only(
                      left: 120,
                    ),
                    child: Center(
                      child: ElevatedButton(
                          // child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            //     child: Row(
                            //       children: [
                            child: Center(
                              child: Text(
                                user.isFollowed == true ? 'Unfollow' : 'Follow',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            //       ],
                            //     ),
                            //   ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFeb6d44)),
                          ),
                          onPressed: () async {
                            //----------Add user in globals following list----------
                            if (user.isFollowed == true) {
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
                                          'Are you sure to delete the recipe?',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Container(
                                          width: double.infinity,
                                          margin:
                                              EdgeInsets.fromLTRB(3, 0, 3, 15),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0,
                                                  right: 30,
                                                  left: 30,
                                                  bottom: 0),
                                              child: Column(
                                                children: [
                                                  ElevatedButton(
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Row(
                                                            children: [
                                                              Center(
                                                                  child: Icon(Icons
                                                                      .delete_outline_rounded)),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFFeb6d44)),
                                                      ),
                                                      onPressed: () {
                                                        followUserService
                                                            .unFollowUser(
                                                                context,
                                                                followId: uId);
                                                        bool exist = AppGlobals
                                                            .allFollowing
                                                            .contains(uId);
                                                        if (exist)
                                                          AppGlobals
                                                              .allFollowing
                                                              .remove(uId);
                                                        setState(() {
                                                          user.isFollowed =
                                                              false;
                                                        });

                                                        Navigator.pop(context);
                                                      }),
                                                  TextButton(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      primary:
                                                          Color(0xFFeb6d44),
                                                      backgroundColor:
                                                          Colors.white,
                                                      //side: BorderSide(color: Colors.deepOrange, width: 1),
                                                      elevation: 0,
                                                      //minimumSize: Size(100, 50),
                                                      //shadowColor: Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
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
                              bool exist =
                                  AppGlobals.allFollowing.contains(uId);
                              if (!exist) {
                                AppGlobals.allFollowing.add(uId);

                                setState(() {
                                  user.isFollowed = true;
                                });
                                await followUserService.followUser(
                                  context,
                                  followId: uId,
                                );
                              }
                            }
                          }
                          //------
// async {
//                     // print('UserId: $_userid ${AppGlobals.userId}');
//                     if (widget.isFollowing == false) {
//                       //----------Add user in globals following list----------
//                       bool exist = AppGlobals.allFollowing.contains(uid);
//                       if (!exist) AppGlobals.allFollowing.add(uid);

//                       setState(() {
//                         // user.isFollowed = true;
//                         widget.users[index].isFollowed = true;
//                       });
//                       //-------------to adding user to followers list----------------
//                       await followUserService.followUser(
//                         context,
//                         followId: uid,
//                       );
//                     }
//                   },

                          //------

                          ),
                    ),
                  ),
//------------------------------------------
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(color: Colors.grey)),
                  // User recipes heading
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.assignment_outlined),
                      ),
                      Text(
                        "${userUsername ?? ''}\'s recipes",
                      )
                    ],
                  ),

                  //Showing user recipes
                  Expanded(
                    child: uId != null
                        ? MyRecipesScreen(userId: uId)
                        : CustomCircularLoader(),
                  ),
                ],
              ),
            ),
    );
  }

  //----------------------------------------------------------
  Widget buildImage() {
    final image = imageURL == null || imageURL == "noImage" || imageURL!.isEmpty
        ? AssetImage('assets/images/defaultUser.png') // NEW
        : NetworkImage(imageURL!);

    // build a circular user image
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipOval(
        child: Material(
          color: Colors.grey.shade400,
          child: Ink.image(
            image: image as ImageProvider<Object>,
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
    );
  }
}
