import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/recipe_tile.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class SearchRecipe extends StatelessWidget {
  bool isFromMealPlan;
  String? mealDay;
  String? mealPlanTypeOfMeal;

  SearchRecipe(
      {Key? key,
      this.recipes = const [],
      required this.isFromMealPlan,
      required this.mealDay,
      required this.mealPlanTypeOfMeal})
      : super(key: key);
  final List<DocumentSnapshot> recipes;

  @override
  Widget build(BuildContext context) {
    if (recipes.length == 0)
      return Center(child: Text('No Recipes Found!'));
    else {
      return ListView.builder(
        itemCount: recipes.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String rid = recipes[index].id;
          Recipe recipe =
              Recipe.fromJson(recipes[index].data() as Map<String, dynamic>);

          return RecipeTile(
            recipeID: rid,
            name: recipe.recipeTitle,
            type: recipe.typeOfMeal,
            category: recipe.category,
            cuisine: recipe.cuisine,
            image: recipe.img1,
            count: recipe.lengthOfIngredients,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (conetxt) => RecipeView(
                    recipeid: rid,
                    isFromMealPlan: isFromMealPlan,
                    mealDay: mealDay,
                    mealPlanTypeOfMeal: mealPlanTypeOfMeal,
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
