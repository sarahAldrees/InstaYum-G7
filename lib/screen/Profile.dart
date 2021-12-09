import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/followers_numbers.dart';
import 'my_mealplans_screen.dart';
import 'my_recipes_screen.dart';
import 'bookmarks_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  // ---------------- Database -------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String userUsername = "";
  String imageURL = "";
  String uId = "";

//getData() to get the data of users like username, image_url from database
  void getData() async {
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        userUsername = userData.data()['username'];
        imageURL = userData.data()['image_url'];
        uId = user.uid;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
  }

//----------------------------------------------------------
  Widget buildImage() {
    final image = imageURL == "noImage" || imageURL.isEmpty || imageURL == null
        ? AssetImage("assets/images/defaultUser.png") // NEW
        : NetworkImage(imageURL);

    // build a circular user image
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipOval(
        child: Material(
          color: Colors.grey.shade400,
          child: Ink.image(
            image: image,
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
      body: DefaultTabController(
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
                          userUsername,
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
              labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              labelColor: Color(0xFFeb6d44),
              indicatorColor: Color(0xFFeb6d44),
              tabs: [
                Tab(
                    icon: Icon(Icons.assignment_outlined),
                    text: ("My recipes")),
                Tab(icon: Icon(Icons.table_view), text: ("My meal plans")),
                Tab(icon: Icon(Icons.bookmark), text: ("Bookmarks")),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  //This list is the content of each tab.
                  // ------------ list item 1 tab view bookmarks screen.
                  MyRecipesScreen(),

                  // ------------ list item 2 tab view bookmarks screen.
                  my_meal_plans(),
                  // ------------ list item 3 tab view bookmarks screen.
                  bookmarked_recipes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
