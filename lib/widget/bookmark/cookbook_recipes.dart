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

List<String> ingredientsList = [];

List<String> dirctionsList = [];

List<String> imageUrlsList = [];

int lengthOfIngredients = 0;

int lengthOfDirections = 0;

int lengthOfImages = 0;

int numberOfRecipes = 0;

String autherId;
String recipeId;

class cookbook_recipesState extends State<cookbook_recipes> {
  getData() async {
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
        setState(() {
          autherId = doc.data()['autherId'];
          recipeId = doc.data()['recipeId'];
        });
//----------------------------------------------------------------
        FirebaseFirestore.instance
            .collection("users")
            .doc(autherId)
            .collection("recipes")
            .doc(recipeId)
            .snapshots()
            .listen((doc) {
          ingredientsList = [];
          dirctionsList = [];
          imageUrlsList = [];
          lengthOfIngredients = doc.data()['length_of_ingredients'];
          lengthOfDirections = doc.data()['length_of_directions'];
          lengthOfImages = doc.data()['image_count'];

          for (int i = 0; i < lengthOfIngredients; i++) {
            {
              ingredientsList.add(
                doc.data()['ing${i + 1}'],
              );
            }
          }
          for (int i = 0; i < lengthOfDirections; i++) {
            dirctionsList.add(
              doc.data()['dir${i + 1}'],
            );
          }
          for (int i = 0; i < lengthOfImages; i++) {
            imageUrlsList.add(
              doc.data()['img${i + 1}'],
            );
          }
          // recipe_image_url = doc.data()['recipe_image_url'],
          recpiesList.add(Recipe(
            autherId: autherId,
            id: doc.id,
            recipeName: doc.data()['recipe_title'],
            typeOfMeal: doc.data()['type_of_meal'],
            category: doc.data()['category'],
            cuisine: doc.data()['cuisine'],
            mainImageURL: doc.data()["img1"],
            dirctions: dirctionsList,
            ingredients: ingredientsList,
            imageUrls: imageUrlsList,
          ));
          setState(() {});
        });
      });
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
