import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/reported_account.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/search_users.dart';
import 'package:instayum/widget/follow_and_notification/follow_user_service.dart';
import 'package:instayum/widget/meal_plan/my_mealplans_screen.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/followers_numbers.dart';
import 'package:instayum/widget/profile/followers_page.dart';
import 'package:instayum/widget/recipe_view/my_recipes_screen.dart';

class UserProfileView extends StatefulWidget {
  final String? userId;
  UserProfileView({required this.userId});
  @override
  State<StatefulWidget> createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  // ---------------- Database -------------------------
  List<DocumentSnapshot> followersList = [];
  List<DocumentSnapshot> followingList = [];
  List<String> followers = [];
  String? userUsername;
  String? imageURL;
  String? uId;
  bool isLoading = true;
  final FollowUserService followUserService = FollowUserService();
  bool isFollowed = false;
  late UserModel user;
  int selectedTab = 0;
  TabController? controller;
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
    print('get user followers and following..');
    // get user followers list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection("followers")
        .get()
        .then((querySnapshot) {
      followersList = querySnapshot.docs;
      _saveFollowers(followersList);
    });
    if (mounted) setState(() {});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('following')
        .get()
        .then((querySnapshot) {
      followingList = querySnapshot.docs;
    });
    if (mounted) setState(() {});
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
        title: Text("${userUsername ?? ''}"),
        actions: [
          IconButton(
              onPressed: () {
                List<String>? userAlreadyReported = [];

                FirebaseFirestore.instance
                    .collection('admin')
                    .doc("reportes")
                    .collection("ReportedAcount")
                    .where('userId', isEqualTo: widget.userId)
                    .get()
                    .then((doc) {
                  if (doc != null && doc.docs.length > 0) {
                    Map<String, dynamic>? data = doc.docs[0].data();
                    ReprtedAccount reprtedAccount =
                        ReprtedAccount.fromJson(data);
                    print("------------------------kk-----kk------mk--------");
                    if (!reprtedAccount.user_already_reported!
                        .contains(AppGlobals.userId)) {
                      reprtedAccount.user_already_reported!
                          .add(AppGlobals.userId!);

                      //       //-------show dailoge about reson----------------
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
                                  'Why are you reporting this?',
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
                                            child: Text(
                                              "Hurting others or bullying",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFeb6d44),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("admin")
                                                  .doc("reportes")
                                                  .collection("ReportedAcount")
                                                  .doc(widget.userId)
                                                  .update({
                                                "Ignore": false,
                                                "no_reports": reprtedAccount
                                                    .user_already_reported!
                                                    .length,
                                                "user_already_reported": FieldValue
                                                    .arrayUnion(reprtedAccount
                                                        .user_already_reported!),
                                                "bullying":
                                                    reprtedAccount.bullying! +
                                                        1,
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Fraudulent",
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
                                              FirebaseFirestore.instance
                                                  .collection("admin")
                                                  .doc("reportes")
                                                  .collection("ReportedAcount")
                                                  .doc(widget.userId)
                                                  .update({
                                                "Ignore": false,
                                                "no_reports": reprtedAccount
                                                    .user_already_reported!
                                                    .length,
                                                "user_already_reported": FieldValue
                                                    .arrayUnion(reprtedAccount
                                                        .user_already_reported!),
                                                "fraudulent":
                                                    reprtedAccount.fraudulent! +
                                                        1,
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Unethical",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFeb6d44),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("admin")
                                                  .doc("reportes")
                                                  .collection("ReportedAcount")
                                                  .doc(widget.userId)
                                                  .update({
                                                "Ignore": false,
                                                "no_reports": reprtedAccount
                                                    .user_already_reported!
                                                    .length,
                                                "user_already_reported": FieldValue
                                                    .arrayUnion(reprtedAccount
                                                        .user_already_reported!),
                                                "unethical":
                                                    reprtedAccount.unethical! +
                                                        1,
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "I don't like it",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFeb6d44),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("admin")
                                                  .doc("reportes")
                                                  .collection("ReportedAcount")
                                                  .doc(widget.userId)
                                                  .update({
                                                "Ignore": false,
                                                "no_reports": reprtedAccount
                                                    .user_already_reported!
                                                    .length,
                                                "user_already_reported": FieldValue
                                                    .arrayUnion(reprtedAccount
                                                        .user_already_reported!),
                                                "IDontLike":
                                                    reprtedAccount.IDontLike! +
                                                        1,
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                              child: const Center(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 30),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xFFeb6d44)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      )))
                            ],
                          );
                        },
                      );
                      //-------------------1---------------------

                      //-----------------------------------------------
                    } else {
                      print("you are reported ");

                      //-------show dailoge about reson----------
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
                                  'You have already reported !!',
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
                                          ElevatedButton(
                                              child: const Center(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 30),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal: 10),
                                                    child: Text(
                                                      "OK     ",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xFFeb6d44)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      )))
                            ],
                          );
                        },
                      );
                      //-----------------------------------------
                    }
                  } else {
                    //-------------------------------
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          title: Column(
                            children: [
                              Text(
                                'Why are you reporting this?',
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
                                        top: 0, right: 30, left: 30, bottom: 0),
                                    child: Column(
                                      children: [
                                        TextButton(
                                          child: Text(
                                            "Hurting others or bullying",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: Color(0xFFeb6d44),
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            userAlreadyReported
                                                .add(AppGlobals.userId ?? '');

                                            ReprtedAccount reprtedAccount =
                                                ReprtedAccount(
                                              userId: widget.userId,
                                              username: userUsername,
                                              user_already_reported:
                                                  userAlreadyReported,
                                              Ignore: false,
                                              no_reports: 1,
                                              fraudulent: 0,
                                              bullying: 1,
                                              unethical: 0,
                                              IDontLike: 0,
                                            );
                                            FirebaseFirestore.instance
                                                .collection("admin")
                                                .doc("reportes")
                                                .collection("ReportedAcount")
                                                .doc(widget.userId)
                                                .set(reprtedAccount.toJson());
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Fraudulent",
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
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            userAlreadyReported
                                                .add(AppGlobals.userId ?? '');

                                            ReprtedAccount reprtedAccount =
                                                ReprtedAccount(
                                              userId: widget.userId,
                                              username: userUsername,
                                              user_already_reported:
                                                  userAlreadyReported,
                                              no_reports: 1,
                                              fraudulent: 1,
                                              bullying: 0,
                                              unethical: 0,
                                              IDontLike: 0,
                                              Ignore: false,
                                            );
                                            FirebaseFirestore.instance
                                                .collection("admin")
                                                .doc("reportes")
                                                .collection("ReportedAcount")
                                                .doc(widget.userId)
                                                .set(reprtedAccount.toJson());

                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Unethical",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: Color(0xFFeb6d44),
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            userAlreadyReported
                                                .add(AppGlobals.userId ?? '');

                                            ReprtedAccount reprtedAccount =
                                                ReprtedAccount(
                                              userId: widget.userId,
                                              username: userUsername,
                                              user_already_reported:
                                                  userAlreadyReported,
                                              no_reports: 1,
                                              fraudulent: 0,
                                              bullying: 0,
                                              unethical: 1,
                                              IDontLike: 0,
                                              Ignore: false,
                                            );
                                            FirebaseFirestore.instance
                                                .collection("admin")
                                                .doc("reportes")
                                                .collection("ReportedAcount")
                                                .doc(widget.userId)
                                                .set(reprtedAccount.toJson());

                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "I don't like it",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: Color(0xFFeb6d44),
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            //----
                                            userAlreadyReported
                                                .add(AppGlobals.userId ?? '');

                                            ReprtedAccount reprtedAccount =
                                                ReprtedAccount(
                                              userId: widget.userId,
                                              username: userUsername,
                                              user_already_reported:
                                                  userAlreadyReported,
                                              no_reports: 1,
                                              fraudulent: 0,
                                              bullying: 0,
                                              unethical: 0,
                                              IDontLike: 1,
                                              Ignore: false,
                                            );
                                            FirebaseFirestore.instance
                                                .collection("admin")
                                                .doc("reportes")
                                                .collection("ReportedAcount")
                                                .doc(widget.userId)
                                                .set(reprtedAccount.toJson());
                                            //----

                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                            child: const Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 30),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                                  child: Text(
                                                    "Cancel      ",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFFeb6d44)),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    )))
                          ],
                        );
                      },
                    );

                    //---------------------------

                  }
                });
              },
              icon: Icon(
                Icons.flag_outlined,
                size: 20,
                color: Colors.white,
              )),
        ],
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

                      if (uId != null)
                        buildButton(
                          context,
                          text: 'Following',
                          isFollowing: true,
                          value: '${followingList.length}',
                        ),
                      buildDivider(),
                      buildButton(
                        context,
                        text: 'Followers',
                        isFollowing: false,
                        value: '${followers.length}',
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 11),
                  //   child:
                  // ),
                  //-------------- follow button-----------
                  Container(
                    margin: const EdgeInsets.only(
                      left: 100,
                      right: 40,
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
                              followers.remove(AppGlobals.userId);
                              followUserService.unFollowUser(context,
                                  followId: uId);
                              bool exist =
                                  AppGlobals.allFollowing.contains(uId);
                              if (exist) AppGlobals.allFollowing.remove(uId);
                              setState(() {
                                user.isFollowed = false;
                              });
                            } else {
                              followers.add(AppGlobals.userId ?? '');
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
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Icon(Icons.assignment_outlined),
                  //     ),
                  //     Text(
                  //       "${userUsername ?? ''}\'s recipes",
                  //     )
                  //   ],
                  // ),

                  // //Showing user recipes
                  // Expanded(
                  //   child: uId != null
                  //       ? MyRecipesScreen(userId: uId)
                  //       : CustomCircularLoader(),
                  // ),
//=========================================NEW DESIGN=====================================

                  DefaultTabController(
                    initialIndex: selectedTab,
                    length: 2,

                    // allows you to build a list of elements that would be scrolled away till the body reached the top

                    // You tab view goes here and its bar view
                    // child: Column(
                    //   children: <Widget>[
                    child:

                        //Container(
                        //   child: Row(
                        //     children: [
                        //       buildImage(),
                        //       if (uId != null) FollowersNumbers(userId: uId),
                        //     ],
                        //   ),
                        // ),

                        // Container(
                        //   margin: EdgeInsets.only(right: 270),
                        //   child: Text(
                        //     "@${userUsername ?? ''}",
                        //     style:
                        //         TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        //   ),
                        // ),

                        //------------------------------------------
                        SizedBox(
                      height: AppGlobals.screenHeight * 0.59,
                      child: Column(
                        children: [
                          TabBar(
                            controller: controller,
                            labelStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                            labelColor: Color(0xFFeb6d44),
                            tabs: [
                              Tab(
                                  icon: Icon(Icons.assignment_outlined),
                                  text: ("Recipes")),
                              Tab(
                                  icon: Icon(Icons.calendar_month),
                                  text: ("Meal plans")),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // ------------ list item 1 tab view bookmarks screen.

                                MyRecipesScreen(
                                  userId: uId,
                                  isFromMealPlan: false,
                                  mealDay: "",
                                  mealPlanTypeOfMeal: "",
                                ),

                                // ------------ list item 2 tab view bookmarks screen.
                                MyMealplanScreen(
                                  day: "",
                                  typeOfMeal: "",
                                  isFromUserProfileView: true,
                                  userID: uId,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

//=========================================NEW DESIGN=====================================
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

  _saveFollowers(List<DocumentSnapshot> followersP) {
    followers.clear();
    for (int i = 0; i < followersP.length; i++) {
      String id = followersP[i].id;
      followers.add(id);
    }
  }

  Widget buildButton(BuildContext context,
          {String? value, String? text, bool isFollowing = false}) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          if (widget.userId == AppGlobals.userId) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowersPage(
                    isFollowing: isFollowing,
                    users: isFollowing == true ? followingList : followersList,
                  ),
                )).then((value) => getData());
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child:
            //-----------------
            Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value ?? '0',
                style: TextStyle(fontSize: 20),
              ),
              //------------------------
              SizedBox(height: 2),
              Text(
                text ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );
}
