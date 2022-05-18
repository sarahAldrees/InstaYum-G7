import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/discover/chatbot/recipe_card.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

import 'dialog_flow.dart';

class RecipeCardScreen extends StatefulWidget {
  String? autherId;
  @override
  RecipeCardScreenState createState() => RecipeCardScreenState();
}

class RecipeCardScreenState extends State<RecipeCardScreen> {
  @override
  void initState() {
    super.initState();
    getRecipeObjects(); // to create a All bookmarked recipes for each user when the user create an account
  }

  String finalText = 'wait until I bring the recipes';
  List<Recipe> recpiesList = [];

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  List<String> imageUrlsList = [];

  int? lengthOfIngredients = 0;

  int? lengthOfDirections = 0;

  int? lengthOfImages = 0;

  static int numberOfRecipes = 0;

  void getRecipeObjects() {
    numberOfRecipes = 0;

    FirebaseFirestore.instance
        .collection("recipes")
        .orderBy("position")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        Map data = doc.data();
        Recipe recipe = Recipe.fromJson(data as Map<String, dynamic>);
        String? recipeName = recipe.recipeTitle;
        String? typeOfMeal = recipe.typeOfMeal;
        String? category = recipe.category;
        String? cuisine = recipe.cuisine;
        String? img1 = recipe.img1;
        String? recipeID = recipe.recipeId;

        bool public = recipe.isPublicRecipe ?? false;

        if (public == true &&
            typeOfMeal == ChatBotState.userPreferredTypeOfMeal &&
            category == ChatBotState.userPreferredCategory &&
            cuisine == ChatBotState.userPreferredCuisine &&
            numberOfRecipes <= 2) {
          setState(() {
            numberOfRecipes++;
          });
          Random random = new Random();
          int randomNumber = random.nextInt(1000000);
          FirebaseFirestore.instance
              .collection("recipes")
              .doc(doc.id)
              .update({"position": randomNumber});

          lengthOfIngredients = recipe.lengthOfIngredients;
          lengthOfDirections = recipe.lengthOfDirections;
          lengthOfImages = recipe.imageCount;

          for (int i = 0; i < lengthOfIngredients!; i++) {
            ingredientsList.add(data['ing${i + 1}']);
          }
          for (int i = 0; i < lengthOfDirections!; i++) {
            dirctionsList.add(data['dir${i + 1}']);
          }
          for (int i = 0; i < lengthOfImages!; i++) {
            imageUrlsList.add(data['img${i + 1}']);
          }
          // add only other user public recipes.

          recpiesList.add(
            Recipe(
              recipeId: doc.id,
              recipeTitle: recipeName,
              typeOfMeal: typeOfMeal,
              category: category,
              cuisine: cuisine,
              img1: img1,
              dirctions: dirctionsList,
              ingredients: ingredientsList,
              imageUrls: imageUrlsList,
            ),
          );
        }
      });
      if (mounted)
        setState(() {
          if (numberOfRecipes == 0)
            setState(() {
              finalText = "There are no suitable recipes";
            });
          else
            setState(() {
              finalText =
                  "Suggested recipes are above,\nAre you happy with these recipes?";
            });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (Recipe recipe in recpiesList)
          RecipeCard(
              recipe.userId,
              recipe.recipeId,
              recipe.recipeTitle,
              recipe.img1,
              recipe.typeOfMeal,
              recipe.category,
              recipe.cuisine,
              recipe.ingredients,
              recipe.dirctions,
              recipe.imageUrls),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                child: Image.asset('assets/images/InstaYum_chatbot.png'),
                backgroundColor: Colors.white,
                radius: 30,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(finalText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
