import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/discover/recipe_card.dart';
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
    // User user = firebaseAuth.currentUser;
    // FirebaseFirestore.instance.collection("users").get()
    numberOfRecipes = 0;

    FirebaseFirestore.instance.collection("recipes").get().then((snapshot) {
      snapshot.docs.shuffle();
      snapshot.docs.forEach((doc) {
        Map data = doc.data();
        Recipe recipe = Recipe.fromJson(data as Map<String, dynamic>);
        String? recipeName = recipe.recipeTitle;
        String? typeOfMeal = recipe.typeOfMeal;
        String? category = recipe.category;
        String? cuisine = recipe.cuisine;
        String? img1 = recipe.img1;
        // autherId = recipe.userId;
        bool public = recipe.isPublicRecipe ?? false;
        // recipe_image_url = data['recipe_image_url'],

        if (public == true &&
            typeOfMeal == ChatBotState.userPreferredTypeOfMeal &&
            category == ChatBotState.userPreferredCategory &&
            cuisine == ChatBotState.userPreferredCuisine &&
            numberOfRecipes <= 2) {
          setState(() {
            numberOfRecipes++;
          });

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
      });
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

  //_____________________The down will be deleted soon_______________________________________________

  // FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
  //   querySnapshot.docs.shuffle();
  //   querySnapshot.docs.forEach((result) {
  //     FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(result.id)
  //         .collection("recipes")
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach(
  //         (doc) => {
  //           ingredientsList = [],
  //           dirctionsList = [],
  //           imageUrlsList = [],
  //           if (doc.data()['type_of_meal'] ==
  //                   ChatBotState.userPreferredTypeOfMeal &&
  //               doc.data()['category'] ==
  //                   ChatBotState.userPreferredCategory &&
  //               doc.data()['cuisine'] == ChatBotState.userPreferredCuisine &&
  //               doc.data()['is_public_recipe'] &&
  //               numberOfRecipes <= 2)
  //             {
  //               setState(() {
  //                 print('the number of founded recipes');
  //                 numberOfRecipes++;
  //                 print(numberOfRecipes);
  //               }),

  //               lengthOfIngredients = doc.data()['length_of_ingredients'],
  //               lengthOfDirections = doc.data()['length_of_directions'],
  //               lengthOfImages = doc.data()['image_count'],

  //               for (int i = 0; i < lengthOfIngredients; i++)
  //                 {
  //                   {
  //                     ingredientsList.add(
  //                       doc.data()['ing${i + 1}'],
  //                     ),
  //                   }
  //                 },
  //               for (int i = 0; i < lengthOfDirections; i++)
  //                 {
  //                   dirctionsList.add(
  //                     doc.data()['dir${i + 1}'],
  //                   ),
  //                 },
  //               for (int i = 0; i < lengthOfImages; i++)
  //                 {
  //                   imageUrlsList.add(
  //                     doc.data()['img${i + 1}'],
  //                   ),
  //                 },
  //               // recipe_image_url = doc.data()['recipe_image_url'],
  //               widget.autherId = doc.data()['user_id'],
  //               recpiesList.add(
  //                 Recipe(
  //                   autherId: doc.data()['user_id'],
  //                   id: doc.id,
  //                   //imageURL: recipe_image_url,
  //                   recipeName: doc.data()['recipe_title'],
  //                   typeOfMeal: doc.data()['type_of_meal'],
  //                   category: doc.data()['category'],
  //                   cuisine: doc.data()['cuisine'],
  //                   mainImageURL: doc.data()["img1"],
  //                   dirctions: dirctionsList,
  //                   ingredients: ingredientsList,
  //                   imageUrls: imageUrlsList,
  //                 ),
  //               ),
  //             }
  //           else
  //             {
  //               print(
  //                   "11111111111111111111111111111111111111111111111111111111111111111"),
  //               print(numberOfRecipes),
  //               print(
  //                   "In recipe card screen we did not find any suitable recipe"),
  //             }
  //         },
  //       );
  //       setState(() {
  //         if (numberOfRecipes == 0)
  //           setState(() {
  //             finalText = "There are no suitable recipes";
  //           });
  //         else
  //           setState(() {
  //             finalText = "Suggested recipes are above";
  //           });
  //       });
  //     });
  //   });
  // });
  //}

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
      crossAxisAlignment: CrossAxisAlignment.start,

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
                child:
                    // Padding(
                    //   padding: const EdgeInsets.all(5),
                    //child:
                    Image.asset('assets/images/InstaYum_chatbot.png'),
                // ),
                backgroundColor: Colors.white,
                radius: 30,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //            Text(this.name,
                  //                style: TextStyle(fontWeight: FontWeight.bold)),
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
