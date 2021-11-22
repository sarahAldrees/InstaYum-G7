import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/recipe.dart';
import 'model/cookbook.dart';

class Data extends StatefulWidget {
  @override
  DataState createState() => DataState();
}

var Cookbook_Data = [
  Cookbook(
    id: 'c1',
    cookbookName: 'Default cookbook',
    imageURLCookbook:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
  ),
];
var Recipes_Data = const [
  Recipe(
    // id: 'r1',
    recipeName: 'Pancakes',
    imageURL:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
    typeOfMeal: "breakfast",
    category: 'c1',
    cuisine: "indian",
    ingredients: [
      '4 Tomatoes',
      '1 Tablespoon of Olive Oil',
      '1 Onion',
    ],
    dirctions: [
      'Tenderize the veal to about 2–4mm, and salt on both sides.',
      'On a flat plate, stir the eggs briefly with a fork.',
      'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
    ],
  ),
  Recipe(
    // id: 'r1',
    recipeName: 'Pancakes',
    imageURL:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
    typeOfMeal: "breakfast",
    category: 'c1',
    cuisine: "indian",
    ingredients: [
      '4 Tomatoes',
      '1 Tablespoon of Olive Oil',
      '1 Onion',
    ],
    dirctions: [
      'Tenderize the veal to about 2–4mm, and salt on both sides.',
      'On a flat plate, stir the eggs briefly with a fork.',
      'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
    ],
  )
];

class DataState extends State<Data> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//  db.collection("users").get().then((querySnapshot) => {
//     querySnapshot.forEach((doc) => {
//         console.log(`${doc.id} => ${doc.data()}`);
//     });

  List<Recipe> recpiesList = [];
//getData() to get the data of users like username, image_url from database
  void getData() async {
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("recpies")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) => {
            recpiesList.add(Recipe(
              id: doc.id,
            ))
          });
    });
    //     .snapshots()
    //     .listen((userData) {
    //   setState(() {
    //     userUsername = userData.data()['username'];
    //     imageURL = userData.data()['image_url'];
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
