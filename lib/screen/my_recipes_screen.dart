import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/recipe_item.dart';

import '../data.dart';

class my_recipes extends StatefulWidget {
  // String autherName;
  // String autherImage;
  String autherId;
  // my_recipes(this.autherName, this.autherImage, this.autherId);

  @override
  State<my_recipes> createState() => _my_recipesState();
}

class _my_recipesState extends State<my_recipes> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getRecipeObjects());

    // WidgetsBinding.instance.addPostFrameCallback((_) => returnGride());
    //we call the method here to get the data immediately when init the page.
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<Recipe> recpiesList = [];

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  int lengthOfIngredients = 0;

  int lengthOfDirections = 0;

  String recipe_image_url = '';

  void getRecipeObjects() {
    User user = firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("recpies")
        .orderBy("timestamp", descending: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
        (doc) => {
          ingredientsList = [],
          dirctionsList = [],
          lengthOfIngredients = doc.data()['length_of_ingredients'],
          lengthOfDirections = doc.data()['length_of_directions'],
          // print(
          //     'Ingredients*******************************************************>>>>>>>>>>>>>>>>>>>>'),
          for (int i = 0; i < lengthOfIngredients; i++)
            {
              {
                ingredientsList.add(
                  doc.data()['ing${i + 1}'],
                ),
                //  print(ingredientsList[i]),
              }
            },
          // print(
          //     'Directions*******************************************************>>>>>>>>>>>>>>>>>>>>'),
          for (int i = 0; i < lengthOfDirections; i++)
            {
              dirctionsList.add(
                doc.data()['dir${i + 1}'],
              ),
              // print(dirctionsList[i]),
            },
          // print(
          //     'Recipe list *******************************************************>>>>>>>>>>>>>>>>>>>>'),
          // print(doc.data()['recipe_image_url']),
          // print(doc.data()['recipe_title']),
          // print(doc.data()['type_of_meal']),
          // print(doc.data()['category']),
          // print(doc.data()['cuisine']),
          //AssetImage("assets/images/defaultUser.png")
          recipe_image_url = doc.data()['recipe_image_url'],
          widget.autherId = doc.data()['user_id'],
          recpiesList.add(
            Recipe(
              id: doc.id,
              imageURL: recipe_image_url,
              recipeName: doc.data()['recipe_title'],
              typeOfMeal: doc.data()['type_of_meal'],
              category: doc.data()['category'],
              cuisine: doc.data()['cuisine'],
              dirctions: dirctionsList,
              ingredients: ingredientsList,
            ),
          ),
        },
      );
      setState(() {});
    });
  }

  // Widget returnGride() {
  //   return GridView.count(
  //     crossAxisCount: 2, // 2 items in each row
  //     crossAxisSpacing: 20,
  //     padding: EdgeInsets.all(25),
  //     // map all available cookbooks and list them in Gridviwe.
  //     children: recpiesList
  //         .map((e) => recipe_Item(
  //               // key,
  //               widget.autherName,
  //               widget.autherImage,
  //               e.id,
  //               e.recipeName,
  //               e.imageURL,
  //               e.typeOfMeal,
  //               e.category,
  //               e.cuisine,
  //               e.ingredients,
  //               e.dirctions,
  //             ))
  //         .toList(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // 2 items in each row
      crossAxisSpacing: 20,
      padding: EdgeInsets.all(25),
      // map all available cookbooks and list them in Gridviwe.
      children: recpiesList
          .map((e) => recipe_Item(
                //key,
                // widget.autherName,
                // widget.autherImage,
                widget.autherId,
                e.id,
                e.recipeName,
                e.imageURL,
                e.typeOfMeal,
                e.category,
                e.cuisine,
                e.ingredients,
                e.dirctions,
              ))
          .toList(),
    );
  }
}
