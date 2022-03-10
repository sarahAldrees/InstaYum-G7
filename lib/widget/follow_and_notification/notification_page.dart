import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/notification_model.dart';
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
    notifications.clear();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Activities'),
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
}
