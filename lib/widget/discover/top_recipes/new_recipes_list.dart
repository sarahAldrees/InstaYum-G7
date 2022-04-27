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
        ],
      ),
    );
  }
}
