import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';
import 'package:instayum/widget/bookmark/cookbook_recipes.dart';
import 'package:instayum/widget/meal_plan/my_mealplans_screen.dart';
import 'package:instayum/widget/profile/followers_numbers.dart';
import '../recipe_view/my_recipes_screen.dart';
import '../bookmark/bookmarks_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'circular_loader.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  // ---------------- Database -------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? userUsername = AppGlobals.userName;
  String? imageURL = AppGlobals.userImage;
  String? uId = AppGlobals.userId;
  bool isLoading = true;

//getData() to get the data of users like username, image_url from database
  void getData() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && AppGlobals.userId == null) {
      print('get User data ${AppGlobals.userId}');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((userData) {
        Map data = userData.data()!;
        AppGlobals.email = data['email'];
        AppGlobals.userName = data['username'];
        //AppGlobals.fullName = data['fullName'];
        AppGlobals.pushToken = data['pushToken'];
        AppGlobals.userImage = data['image_url'];
        AppGlobals.userId = user.uid;

        userUsername = data['username'];
        imageURL = data['image_url'];
        uId = user.uid;

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getData();
    });
  }

//----------------------------------------------------------
  Widget buildImage() {
    final image = imageURL == "noImage" || imageURL!.isEmpty || imageURL == null
        ? AssetImage("assets/images/defaultUser.png") // NEW
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

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? CustomCircularLoader()
          : DefaultTabController(
              length: 3,

              // allows you to build a list of elements that would be scrolled away till the body reached the top

              // You tab view goes here and its bar view
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            buildImage(),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "@${userUsername ?? ''}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: FollowersNumbers(),
                        ),
                      ],
                    ),
                  ),
                  //
                  TabBar(
                    labelStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    labelColor: Color(0xFFeb6d44),
                    indicatorColor: Color(0xFFeb6d44),
                    tabs: [
                      Tab(
                          icon: Icon(Icons.assignment_outlined),
                          text: ("My recipes")),
                      Tab(
                          icon: Icon(Icons.table_view),
                          text: ("My meal plans")),
                      Tab(icon: Icon(Icons.bookmark), text: ("Bookmarks")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        //This list is the content of each tab.
                        // ------------ list item 1 tab view bookmarks screen.
                        uId != null
                            ? MyRecipesScreen(userId: uId)
                            : CustomCircularLoader(),

                        // ------------ list item 2 tab view bookmarks screen.
                        my_meal_plans(),
                        // ------------ list item 3 tab view bookmarks screen.

                        BookmarkedRecipes("", "")
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
