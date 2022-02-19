import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/profile/circular_loader.dart';

import 'recipe_item.dart';

// import '../bookmark/data.dart';

class MyRecipesScreen extends StatefulWidget {
  // String autherName;
  // String autherImage;
  String? userId;
  MyRecipesScreen({this.userId});

  // my_recipes(this.autherName, this.autherImage, this.autherId);

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getRecipeObjects());
    //we call the method here to get the data immediately when init the page.
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Recipe> recpiesList = [];
  List<String>? ingredientsList = [];
  List<String>? dirctionsList = [];
  List<String>? imageUrlsList = [];
  int? lengthOfIngredients = 0;
  int? lengthOfDirections = 0;
  int? lengthOfImages = 0;
  String? autherId;
  bool isLoading = true;

  void getRecipeObjects() {
    // User user = firebaseAuth.currentUser!;

    if (widget.userId != null) {
      FirebaseFirestore.instance
          // .collection("users")
          // .doc(user.uid)
          .collection("recipes")
          .where("user_id", isEqualTo: widget.userId)
          .orderBy("timestamp", descending: true)
          .get()
          .then((snapshot) {
        recpiesList.clear();

        snapshot.docs.forEach(
          (doc) {
            Map data = doc.data();
            Recipe recipe = Recipe.fromJson(data as Map<String, dynamic>);
            String? recipeName = recipe.recipeTitle;
            String? typeOfMeal = recipe.typeOfMeal;
            String? category = recipe.category;
            String? cuisine = recipe.cuisine;
            String? img1 = recipe.img1;
            autherId = recipe.userId;
            bool public = recipe.isPublicRecipe ?? false;
            // recipe_image_url = data['recipe_image_url'],

            lengthOfIngredients = recipe.lengthOfIngredients;
            lengthOfDirections = recipe.lengthOfDirections;
            lengthOfImages = recipe.imageCount;

            for (int i = 0; i < lengthOfIngredients!; i++) {
              ingredientsList!.add(data['ing${i + 1}']);
            }
            for (int i = 0; i < lengthOfDirections!; i++) {
              dirctionsList!.add(data['dir${i + 1}']);
            }
            for (int i = 0; i < lengthOfImages!; i++) {
              imageUrlsList!.add(data['img${i + 1}']);
            }

            if (widget.userId != AppGlobals.userId) {
              // add only other user public recipes.
              if (public == true) {
                recpiesList.add(
                  Recipe(
                    recipeId: doc.id,
                    //imageURL: recipe_image_url,
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
            } else {
              // add current user all recipes
              recpiesList.add(
                Recipe(
                  recipeId: doc.id,
                  //imageURL: recipe_image_url,
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
          },
        );
        isLoading = false;
        setState(() {});
      }).catchError((e) => print("error fetching data: $e"));
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => getRecipeObjects());
    return isLoading
        ? CustomCircularLoader()
        : recpiesList.isNotEmpty
            ? GridView.count(
                crossAxisCount: 2, // 2 items in each row
                crossAxisSpacing: 20,
                padding: EdgeInsets.all(20),
                mainAxisSpacing: 10,
                // map all available cookbooks and list them in Gridviwe.
                children: recpiesList
                    .map((e) => RecipeItem(
                        "",
                        //  e.key,
                        // widget.autherName,
                        // widget.autherImage,
                        e.userId,
                        e.recipeId,
                        e.recipeTitle,
                        e.img1,
                        e.typeOfMeal,
                        e.category,
                        e.cuisine,
                        e.ingredients,
                        e.dirctions,
                        e.imageUrls
                        // e.ingredients,
                        // e.dirctions,
                        // e.imageUrls,
                        ))
                    .toList(),
              )
            : Center(child: Text('No recipes yet'));
  }
}
