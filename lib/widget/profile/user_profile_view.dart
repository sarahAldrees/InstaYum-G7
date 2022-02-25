import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_colors.dart';
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

//getData() to get the data of users like username, image_url from database
  void getData() async {
    if (widget.userId != null) {
      print('get User data ${widget.userId}');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get()
          .then((userData) {
        Map data = userData.data()!;

        userUsername = data['username'];
        imageURL = data['image_url'];
        uId = userData.id;

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
        title: Text("${userUsername ?? ''}"),
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
                      left: 110,
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
                                "  Follow  ",
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
                          onPressed: () {}),
                    ),
                  ),
//------------------------------------------
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
