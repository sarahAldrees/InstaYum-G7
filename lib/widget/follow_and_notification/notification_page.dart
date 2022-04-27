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
                if (notifications.isEmpty) {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        title: Text(
                          'Delete all notifications ',
                          style: TextStyle(
                              fontSize: 19,
                              color: Theme.of(context).accentColor),
                        ),
                        content: Text(
                          'Are you sure to delete all notifications?',
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
                              "Cancel",
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
                              "Clear",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              _clearActiveites();

                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
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
