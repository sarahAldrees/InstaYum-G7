import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/user.dart';
import 'package:instayum1/utils/user_preferences.dart';
import 'package:instayum1/widget/followers_numbers.dart';
import 'package:instayum1/widget/profile_widget.dart';
import 'my_mealplans_screen.dart';
import 'my_recipes_screen.dart';
import 'bookmarks_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => profile2();
}

class profile2 extends State<profile> {
  // ---------------- Database -------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String userUsername = "";
  String imageURL = "";
  dynamic data;
//getData() to get the data of users like username, image_url from database
  Future<void> getData() async {
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        imageURL = userData.data()['image_url'];
        userUsername = userData.data()['username'];
      });
    });

    //   final DocumentReference document =   Firestore.instance.collection("listofprods").document('ac1');

    // await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
    //  setState(() {
    //    data =snapshot.data;
    //  });
    // });
    // final DocumentReference document =
    //     FirebaseFirestore.instance.collection("users").doc(user.uid);

    // await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
    //   setState(() {
    //     print('in profile the data are');
    //     print(snapshot.data()['image_url']);
    //     print(snapshot.data()['username']);
    //     imageURL = snapshot.data()['image_url'];
    //     userUsername = snapshot.data()['username'];
    //   });
    // });
  }

  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
  }

//----------------------------------------------------------
  Widget buildImage() {
    final image = imageURL == "noImage" || imageURL.isEmpty || imageURL == null
        ? AssetImage("assets/images/defaultUser.png") // NEW
        : NetworkImage(imageURL);
    // : imageURL.isNotEmpty
    //     ? NetworkImage(imageURL)
    //     : NetworkImage(imageURL);

    // build a circular user image
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipOval(
        child: Material(
          color: Colors.grey.shade400,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery

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
                        child: Text(userUsername),
                      ),
                    ],
                  ),
                  Center(
                    child: FollowersNumbers(),
                  ),
                ],
              ),
            ),
            TabBar(
              labelColor: Color(0xFFeb6d44),
              indicatorColor: Color(0xFFeb6d44),
              tabs: [
                Tab(icon: Icon(Icons.assessment_rounded), text: ("My recipe")),
                Tab(icon: Icon(Icons.table_view), text: ("My meal plans")),
                Tab(icon: Icon(Icons.bookmark), text: ("Bookmarks")),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  //This list is the content of each tab.
                  // ------------ list item 1 tab view bookmarks screen.
                  my_recipes(userUsername, imageURL),

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
