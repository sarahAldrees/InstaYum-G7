import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/recipe.dart';
import '../../model/cookbook.dart';
import 'bookmarks_recipes_screen.dart';

class AddNewCookBook extends StatefulWidget {
  @override
  AddNewCookBookState createState() => AddNewCookBookState();
}

var Cookbooks_List = [
  Cookbook(
    id: 'c1',
    cookbookName: 'Default cookbook',
    imageURLCookbook:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
  ),
];

class AddNewCookBookState extends State<AddNewCookBook> {
// to just create an empty cookbook
  static void createNewCookBook(String cookBookTitle) async {
    print("ADd new cookbook method");
    print(cookBookTitle);

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
      "cookbook_id": "we will see later",
      "cookBook_title": cookBookTitle,
      "cookbook_img_url": "The url of default",
    });

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
