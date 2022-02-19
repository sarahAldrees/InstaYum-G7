import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  int? lengthOfIngredients;
  int? lengthOfDirections;
  String? cuisine;
  String? recipeTitle;
  String? userId;
  String? recipeId;
  bool? isPublicRecipe;
  int? imageCount;
  String? category;
  String? typeOfMeal;
  String? img1;
  Timestamp? timestamp;
  List<String>? ingredients;
  List<String>? dirctions;
  List<String>? imageUrls;

  // // final Key key; //??
  // final String autherId;
  // final String id; //change to user id
  // final String recipeName;
  // final String mainImageURL;
  // final String category;
  // final String typeOfMeal;
  // final String cuisine;
  // final List<String> ingredients;
  // final List<String> dirctions;
  // final List<String> imageUrls;

  Recipe({
    // @required this.key,
    // @required this.autherId,
    // @required this.id,
    // @required this.recipeName,
    // @required this.mainImageURL,
    // @required this.typeOfMeal,
    // @required this.category,
    // @required this.cuisine,
    // @required this.ingredients,
    // @required this.dirctions,
    // @required this.imageUrls,

    this.lengthOfIngredients,
    this.lengthOfDirections,
    this.cuisine,
    this.recipeTitle,
    this.userId,
    this.recipeId,
    this.isPublicRecipe,
    this.imageCount,
    this.category,
    this.typeOfMeal,
    this.img1,
    this.timestamp,
    this.dirctions,
    this.imageUrls,
    this.ingredients,
  });

  Recipe.fromJson(Map<String, dynamic> json) {
    lengthOfIngredients = json['length_of_ingredients'];
    lengthOfDirections = json['length_of_directions'];
    cuisine = json['cuisine'];
    recipeTitle = json['recipe_title'];
    userId = json['user_id'];
    recipeId = json['recipe_id'];
    isPublicRecipe = json['is_public_recipe'];
    imageCount = json['image_count'];
    category = json['category'];
    typeOfMeal = json['type_of_meal'];
    img1 = json['img1'];
    timestamp = json['timestamp'];
    dirctions = json['dirctions'];
    imageUrls = json['imageUrls'];
    ingredients = json['ingredients'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['length_of_ingredients'] = this.lengthOfIngredients;
    data['length_of_directions'] = this.lengthOfDirections;
    data['cuisine'] = this.cuisine;
    data['recipe_title'] = this.recipeTitle;
    data['user_id'] = this.userId;
    data['recipe_id'] = this.recipeId;
    data['is_public_recipe'] = this.isPublicRecipe;
    data['image_count'] = this.imageCount;
    data['category'] = this.category;
    data['type_of_meal'] = this.typeOfMeal;
    data['img1'] = this.img1;
    data['timestamp'] = this.timestamp;
    //data['dirctions'] = this.dirctions; // because they are null in the database
    data['imageUrls'] = this.imageUrls;
    //data['ingredients'] = this.ingredients; // because they are null in the database

    return data;
  }
}
