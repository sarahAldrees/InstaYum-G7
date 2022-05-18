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
  int? position;
  List<String>? ingredients;
  List<String>? dirctions;
  List<String>? imageUrls;
  int? bookmarkCounter;
  int? mealPlanCounter;
  int? weeklyBookmarkCount;

  Recipe(
      {this.lengthOfIngredients,
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
      this.position,
      this.dirctions,
      this.imageUrls,
      this.ingredients,
      this.bookmarkCounter,
      this.mealPlanCounter,
      this.weeklyBookmarkCount});

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
    position = json['position'];
    dirctions = json['dirctions'];
    imageUrls = json['imageUrls'];
    ingredients = json['ingredients'];
    bookmarkCounter = json['bookmarkCounter'];
    mealPlanCounter = json['mealPlanCounter'];
    weeklyBookmarkCount = json['weeklyBookmarkCount'];
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
    data['position'] = this.position;
    data['bookmarkCounter'] = this.bookmarkCounter;
    data['mealPlanCounter'] = this.mealPlanCounter;
    data['imageUrls'] = this.imageUrls;
    data['weeklyBookmarkCount'] = this.weeklyBookmarkCount;

    return data;
  }
}
