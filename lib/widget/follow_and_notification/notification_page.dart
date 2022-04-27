import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/model/notification_model.dart';
import 'package:instayum/widget/follow_and_notification/notification_service.dart';
import 'package:instayum/widget/follow_and_notification/notification_tile.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/user_profile_view.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  //getData() to get the data of users notifications from database
  void getData() async {
    MainPages.notificationCounter = 0;

    notifications.clear();
    resetNotificationsCount();
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users/")
        .doc(AppGlobals.userId)
        .collection("notifications")
        .orderBy('date', descending: true)
        .get();

    // Get data from docs and convert map to List
    List<DocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      notifications = docs
          .map((doc) => NotificationModel.fromJson(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    }
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainPages()));
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Activities'),
        actions: [
          TextButton(
              onPressed: () {
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
                            'Are you sure to clear all notifications ?',
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
                                    ElevatedButton(
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Row(
                                              children: [
                                                Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Icon(Icons
                                                      .delete_outline_rounded),
                                                )),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      "Clear",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFFeb6d44)),
                                        ),
                                        onPressed: () {
//                                           FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(AppGlobals.userId)
//                                               .collection("notifications")
//                                            .get().then((snapshot) {
//   for (DocumentSnapshot ds in snapshot.docs){
//     ds.reference.delete();
//   }
//   );

// });

                                          _clearActiveites();

                                          Navigator.pop(context);
                                        }),
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
                                                BorderRadius.circular(10)),
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
              },
              child: Text("Clear",
                  style: TextStyle(color: Colors.white, fontSize: 16)))
        ],
      ),
      // showing list of notifications
      body: Container(
        child: !isLoading
            ? notifications.isNotEmpty
                ? ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      //display notfication as a tile
                      return NotificationTile(
                        title1: notifications[index].title1,
                        title2: notifications[index].title2,
                        description: notifications[index].description,
                        userImage: notifications[index].userImage,
                        date: notifications[index].date,
                        onTap: () {
                          if (notifications[index].type == 'follow') {
                            //navigate to user profile page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ccontext) => UserProfileView(
                                      userId: notifications[index].userId),
                                ));
                          } else {
                            //navigate to view recipe page
                            print('recipeId: ${notifications[index].recipeId}');
                            if (notifications[index].recipeId != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (conetxt) => RecipeView(
                                      recipeid: notifications[index].recipeId,
                                      isFromMealPlan: false,
                                    ),
                                  ));
                            }
                          }
                        },
                      );
                    },
                  )
                : Center(child: Text('No notifications'))
            : CustomCircularLoader(),
      ),
    );
  }

  void _clearActiveites() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("notifications")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    notifications.clear();
    setState(() {});
  }
}
