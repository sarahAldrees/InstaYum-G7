import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/discover/recipe_card.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';

import 'dialog_flow.dart';

class RecipeCardScreen extends StatefulWidget {
  String autherId;
  @override
  RecipeCardScreenState createState() => RecipeCardScreenState();
}

class RecipeCardScreenState extends State<RecipeCardScreen> {
  @override
  void initState() {
    super.initState();
    getRecipeObjects(); // to create a default cookbook for each user when the user create an account
  }

  List<Recipe> recpiesList = [];

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  List<String> imageUrlsList = [];

  int lengthOfIngredients = 0;

  int lengthOfDirections = 0;

  int lengthOfImages = 0;

  int numberOfRecipes = 0;

  void getRecipeObjects() {
    // User user = firebaseAuth.currentUser;
    // FirebaseFirestore.instance.collection("users").get()

    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(result.id)
            .collection("recipes")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) => {
              ingredientsList = [],
              dirctionsList = [],
              imageUrlsList = [],

              // String userPreferredCategory = '';
              // String userPreferredCuisine = '';
              if (doc.data()['type_of_meal'] ==
                      ChatBotState.userPreferredTypeOfMeal &&
                  doc.data()['category'] ==
                      ChatBotState.userPreferredCategory &&
                  doc.data()['cuisine'] == ChatBotState.userPreferredCuisine &&
                  doc.data()['is_public_recipe'] &&
                  numberOfRecipes <= 3)
                {
                  print(
                      "2222222222222222222222222222222222222222222222222222222"),
                  print("number or recipes in the list is: "),
                  print(numberOfRecipes),
                  numberOfRecipes++,
                  lengthOfIngredients = doc.data()['length_of_ingredients'],
                  lengthOfDirections = doc.data()['length_of_directions'],
                  lengthOfImages = doc.data()['image_count'],

                  for (int i = 0; i < lengthOfIngredients; i++)
                    {
                      {
                        ingredientsList.add(
                          doc.data()['ing${i + 1}'],
                        ),
                      }
                    },
                  for (int i = 0; i < lengthOfDirections; i++)
                    {
                      dirctionsList.add(
                        doc.data()['dir${i + 1}'],
                      ),
                    },
                  for (int i = 0; i < lengthOfImages; i++)
                    {
                      imageUrlsList.add(
                        doc.data()['img${i + 1}'],
                      ),
                    },
                  // recipe_image_url = doc.data()['recipe_image_url'],
                  widget.autherId = doc.data()['user_id'],
                  recpiesList.add(
                    Recipe(
                      id: doc.id,
                      //imageURL: recipe_image_url,
                      recipeName: doc.data()['recipe_title'],
                      typeOfMeal: doc.data()['type_of_meal'],
                      category: doc.data()['category'],
                      cuisine: doc.data()['cuisine'],
                      mainImageURL: doc.data()["img1"],
                      dirctions: dirctionsList,
                      ingredients: ingredientsList,
                      imageUrls: imageUrlsList,
                    ),
                  ),
                }
              else
                {
                  print(
                      "11111111111111111111111111111111111111111111111111111111111111111"),
                  print(
                      "In recipe card screen we did not find any suitable recipe")
                }
            },
          );
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   scrollDirection: Axis.vertical,
    //   shrinkWrap: true,
    //   // crossAxisCount: 1, // 2 items in each row
    //   //crossAxisSpacing: 20,
    //   padding: EdgeInsets.all(20),
    //   // mainAxisSpacing: 10,
    //   // map all available cookbooks and list them in Gridviwe.
    //   children: recpiesList
    //       .map((e) => RecipeCard(
    //           //key,
    //           // widget.autherName,
    //           // widget.autherImage,
    //           widget.autherId,
    //           e.id,
    //           e.recipeName,
    //           e.mainImageURL,
    //           e.typeOfMeal,
    //           e.category,
    //           e.cuisine,
    //           e.ingredients,
    //           e.dirctions,
    //           e.imageUrls))
    //       .toList(),
    // );
    return Column(
      //   //appBar: AppBar(
      //   // title: Row(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: [
      //   //     Icon(Icons.restaurant_menu),
      //   //     SizedBox(width: 10),
      //   //     Text('Food Recipes'),
      //   //   ],
      //   // ),
      //   // ),
      children: [
        for (Recipe recipe in recpiesList)
          RecipeCard(
              widget.autherId,
              recipe.id,
              recipe.recipeName,
              recipe.mainImageURL,
              recipe.typeOfMeal,
              recipe.category,
              recipe.cuisine,
              recipe.ingredients,
              recipe.dirctions,
              recipe.imageUrls)

        // recpiesList
        //   .map((e) =>
        //  RecipeCard(
        //     //key,
        //     // widget.autherName,
        //     // widget.autherImage,
        //     widget.autherId,
        //     e.id,
        //     e.recipeName,
        //     e.mainImageURL,
        //     e.typeOfMeal,
        //     e.category,
        //     e.cuisine,
        //     e.ingredients,
        //     e.dirctions,
        //     e.imageUrls))
        // .toList(),
        // RecipeCard(
        //   title: 'My recipe',
        //   rating: '4.9',
        //   // cookTime: '30 min',
        //   thumbnailUrl:
        //       'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
        // ),
      ],
    );
  }
}
