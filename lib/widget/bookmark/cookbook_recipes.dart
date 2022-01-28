import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instayum1/model/cookbook.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/bookmark/add_new_cookbook.dart';
import 'package:instayum1/widget/pickers/cookbook_image_picker.dart';
import 'package:instayum1/widget/recipe_view/recipe_item.dart';
import 'add_new_cookbook.dart';
import 'package:instayum1/widget/bookmark/cookbook_item.dart';

class cookbook_recipes extends StatefulWidget {
  @override
  String cookbookID;

  cookbook_recipes(this.cookbookID);

  State<cookbook_recipes> createState() => cookbook_recipesState();
}

List<Recipe> recpiesList = [];

String autherId;

class cookbook_recipesState extends State<cookbook_recipes> {
  getData() async {
    //---------------------retriving data--------------------
    //final FirebaseAuth _auth = await FirebaseAuth.instance;
    //final currentUser = _auth.currentUser;

//------------- .collection("users")
    //setState(() {});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .collection("bookmarked_recipe")
        .snapshots()
        .listen((data) {
      recpiesList.clear();
      data.docs.forEach((doc) {
        recpiesList.add(
          Recipe(
            autherId: doc.data()['autherId'],
            id: doc.data()['recipeId'],
            recipeName: doc.data()['recipeName'],
            typeOfMeal: doc.data()['typeOfMeal'],
            category: doc.data()['category'],
            cuisine: doc.data()['cuisine'],
            mainImageURL: doc.data()["img1"],
            dirctions: List.from(doc.data()["dirctions"]),
            ingredients: List.from(doc.data()["ingredients"]),
            imageUrls: List.from(doc.data()["imageUrls"]),
          ),
        );
      });
      if (this.mounted) {
        setState(() {
          recpiesList;
        });
      }
      //--------------------------------
    });
  }

  void initState() {
    super.initState();
    getData();
    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   recpiesList;
    // });
    print(autherId);
    return Scaffold(
      body: GridView.count(
          crossAxisCount: 2, // 2 items in each row
          crossAxisSpacing: 20,
          padding: EdgeInsets.all(20),
          mainAxisSpacing: 10,
          children: [
            ...recpiesList
                .map((e) => RecipeItem(
                    e.autherId,
                    e.id,
                    e.recipeName,
                    e.mainImageURL,
                    e.typeOfMeal,
                    e.category,
                    e.cuisine,
                    e.ingredients,
                    e.dirctions,
                    e.imageUrls))
                .toList(),
          ]),
    );
  }
}
