import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/pickers/cookbook_image_picker.dart';
import 'package:instayum1/widget/recipe_view/comment.dart';
import '../../model/recipe.dart';
import '../../model/cookbook.dart';
import 'bookmarks_recipes_screen.dart';

class AddNewCookBook extends StatefulWidget {
  @override
  AddNewCookBookState createState() => AddNewCookBookState();
}

class AddNewCookBookState extends State<AddNewCookBook> {
// to just create an empty cookbook
  static void createNewCookBook(String cookBookTitle) async {
    DateTime timestamp = DateTime.now();

    print("Add new cookbook method");
    print(cookBookTitle);
    String cookbookImageUrl = CookbookImagePickerState.uploadedFileURL;
    if (cookbookImageUrl == null) cookbookImageUrl = 'noImage';

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;
    print(currentUser.uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection(
            "cookbooks") // create new collcetion of recipes inside user document to save all of the user's recipes
        .doc(cookBookTitle)
        .set({
      "cookbook_id": cookBookTitle,
      // "cookBook_title": cookBookTitle,//we will see later
      "cookbook_img_url": cookbookImageUrl,
      "timestamp": timestamp,
    });
    // timestamp = DateTime.now(); // to update the time and make the default upper
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(currentUser.uid)
    //     .collection("cookbooks")
    //     .doc("All bookmarked recipes")
    //     .update({"timestamp": timestamp});

    //*****************************WE WILL WORK ON IT LATER */
    // await FirebaseFirestore.instance.collection("users")
    //     .doc(currentUser.uid)
    //     .collection(
    //         "cookbooks") // create new collcetion of recipes inside user document to save all of the user's recipes
    //     .doc()
    //     .set({
    //   "cookbook_id": cookBookTitle,
    //   // "cookBook_title": cookBookTitle,//we will see later
    //   "cookbook_img_url": cookbookImageUrl,
    //   "timestamp": timestamp,
    // });
    //*****************************WE WILL WORK ON IT LATER */

// to add the recipes to the cookbook
    // .collection(cookBookTitle + "_recipes")
    // .doc("empty") // the id of recipes
    // .set({"empty": "empty"});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
