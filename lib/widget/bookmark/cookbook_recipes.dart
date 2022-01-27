import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instayum1/model/cookbook.dart';
import 'package:instayum1/widget/bookmark/add_new_cookbook.dart';
import 'package:instayum1/widget/pickers/cookbook_image_picker.dart';
import 'add_new_cookbook.dart';
import 'package:instayum1/widget/bookmark/cookbook_item.dart';

class cookbook_recipes extends StatefulWidget {
  @override
  State<cookbook_recipes> createState() => cookbook_recipesState();
}

class cookbook_recipesState extends State<cookbook_recipes> {
  addRecipeToTheCookBook(String recipeId, String cookBookTitle) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;
    print(currentUser.uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("cookbooks")
        .doc(cookBookTitle)
        .collection("bookmarkedRecipes")
        .doc(recipeId);
    // .set();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // GridView.count(
//                                 crossAxisCount: 2, // 2 items in each row
//                                 padding: EdgeInsets.all(25),
//                                 // map all available cookbooks and list them in Gridviwe.
//                                 children: bookmarked_recipesState.Cookbooks_List.map(
//                                         (c) => cookbook_item(
//                                               // Key,
//                                               c.id,
//                                               // c.cookbookName,
//                                               c.imageURLCookbook,
//                                             )).toList(),
//                           ),
      ],
    );
  }
}
// GridView.count(
//                                 crossAxisCount: 2, // 2 items in each row
//                                 padding: EdgeInsets.all(25),
//                                 // map all available cookbooks and list them in Gridviwe.
//                                 children: bookmarked_recipesState.Cookbooks_List.map(
//                                         (c) => cookbook_item(
//                                               // Key,
//                                               c.id,
//                                               // c.cookbookName,
//                                               c.imageURLCookbook,
//                                             )).toList(),
//                           ),
