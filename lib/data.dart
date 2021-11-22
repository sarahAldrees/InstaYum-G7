import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/recipe.dart';
import 'model/cookbook.dart';

class RecipeData extends StatefulWidget {
  @override
  RecipeDataState createState() => RecipeDataState();
}

var Cookbook_Data = [
  Cookbook(
    id: 'c1',
    cookbookName: 'Default cookbook',
    imageURLCookbook:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
  ),
];
// var Recipes_Data = const [
//   Recipe(
//     // id: 'r1',
//     recipeName: 'Pancakes',
//     imageURL:
//         'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
//     typeOfMeal: "breakfast",
//     category: 'c1',
//     cuisine: "indian",
//     ingredients: [
//       '4 Tomatoes',
//       '1 Tablespoon of Olive Oil',
//       '1 Onion',
//     ],
//     dirctions: [
//       'Tenderize the veal to about 2–4mm, and salt on both sides.',
//       'On a flat plate, stir the eggs briefly with a fork.',
//       'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
//     ],
//   ),
//   Recipe(
//     // id: 'r1',
//     recipeName: 'Pancakes',
//     imageURL:
//         'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
//     typeOfMeal: "breakfast",
//     category: 'c1',
//     cuisine: "indian",
//     ingredients: [
//       '4 Tomatoes',
//       '1 Tablespoon of Olive Oil',
//       '1 Onion',
//     ],
//     dirctions: [
//       'Tenderize the veal to about 2–4mm, and salt on both sides.',
//       'On a flat plate, stir the eggs briefly with a fork.',
//       'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
//     ],
//   )
// ];
// List<Recipe> recpiesList = [];

class RecipeDataState extends State<RecipeData> {
  // static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // List<Recipe> recpiesList = [];
  // List<String> ingredientsList = [];
  // List<String> dirctionsList = [];
  // int lengthOfIngredients = 0;
  // int lengthOfDirections = 0;

  // void getRecipeObjects() {
  //   //userData.data()['username'];
  //   User user = firebaseAuth.currentUser;
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user.uid)
  //       .collection("recpies")
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) => {
  //           lengthOfIngredients = doc.data()['length_of_ingredients'],
  //           lengthOfDirections = doc.data()['length_of_directions'],
  //           print(
  //               'Ingredients*******************************************************>>>>>>>>>>>>>>>>>>>>'),
  //           for (int i = 0; i < lengthOfIngredients; i++)
  //             {
  //               ingredientsList.add(
  //                 doc.data()['ing${i + 1}'],
  //               ),
  //               print(i),
  //             },
  //           print(
  //               'Directions*******************************************************>>>>>>>>>>>>>>>>>>>>'),
  //           for (int i = 0; i < lengthOfDirections; i++)
  //             {
  //               dirctionsList.add(
  //                 doc.data()['dir${i + 1}'],
  //               ),
  //               print(i),
  //             },
  //           print(
  //               'Recipe list *******************************************************>>>>>>>>>>>>>>>>>>>>'),
  //           print(doc.data()['recipe_image_url']),
  //           print(doc.data()['recipe_title']),
  //           print(doc.data()['type_of_meal']),
  //           print(doc.data()['category']),
  //           print(doc.data()['cuisine']),
  //           recpiesList.add(
  //             Recipe(
  //               id: doc.id,
  //               imageURL: doc.data()['recipe_image_url'],
  //               recipeName: doc.data()['recipe_title'],
  //               typeOfMeal: doc.data()['type_of_meal'],
  //               category: doc.data()['category'],
  //               cuisine: doc.data()['cuisine'],
  //               dirctions: dirctionsList,
  //               ingredients: ingredientsList,
  //             ),
  //           )
  //         });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
