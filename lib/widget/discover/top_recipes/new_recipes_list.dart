import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/discover/search/search_recipe.dart';

class NewRecipesForU extends StatelessWidget {
  NewRecipesForU({Key? key, this.recipes = const []}) : super(key: key);
  final List<DocumentSnapshot> recipes;

  final List<DocumentSnapshot> _newRecipes = [];

  void _getNewRecipes() async {
    if (recipes.isNotEmpty) {
      _newRecipes.clear();
      int length = recipes.length > 5 ? 5 : recipes.length;
      for (int i = 0; i < length; i++) {
        _newRecipes.add(recipes[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getNewRecipes();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Recipes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          SearchRecipe(
            recipes: _newRecipes,
            isFromMealPlan: false,
            mealDay: '',
            mealPlanTypeOfMeal: '',
          ),
          // recipes.isNotEmpty
          //     ? SizedBox(
          //         height: AppGlobals.screenHeight * 0.35,
          //         child: ListView.builder(
          //           // reverse: true,
          //           shrinkWrap: true,
          //           scrollDirection: Axis.horizontal,
          //           physics: const BouncingScrollPhysics(),
          //           itemCount: recipes.length > 10 ? 10 : recipes.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             // return RecipeTile(
          //             //   recipeID: rid,
          //             //   name: recipe.recipeTitle,
          //             //   type: recipe.typeOfMeal,
          //             //   category: recipe.category,
          //             //   cuisine: recipe.cuisine,
          //             //   image: recipe.img1,
          //             //   count: recipe.lengthOfIngredients,
          //             //   onTap: () {
          //             //     Navigator.push(
          //             //       context,
          //             //       MaterialPageRoute(
          //             //         builder: (conetxt) => RecipeView(recipeid: rid),
          //             //       ),
          //             //     );
          //             //   },
          //             // );
          //             return TopRecipeCard(
          //               index: index,
          //               title: recipes[index].recipeTitle,
          //               recipeId: recipes[index].recipeId,
          //               image: recipes[index].img1,
          //               onTap: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => RecipeView(
          //                         recipeid: recipes[index].recipeId,
          //                       ),
          //                     ));
          //               },
          //             );
          //           },
          //         ),
          //       )
          //     : const Text("No recipes found"),
        ],
      ),
    );
  }
}
