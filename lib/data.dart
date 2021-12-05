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

class RecipeDataState extends State<RecipeData> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
