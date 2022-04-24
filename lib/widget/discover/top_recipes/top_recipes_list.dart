import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/discover/top_recipes/top_recipe_card.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class TopWeeklyRecipes extends StatelessWidget {
  const TopWeeklyRecipes({Key? key, this.recipes = const []}) : super(key: key);
  final List<Recipe> recipes;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Weekly Recipes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          recipes.isNotEmpty
              ? SizedBox(
                  height: AppGlobals.screenHeight * 0.3,
                  child: ListView.builder(
                    // reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: recipes.length > 10 ? 10 : recipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TopRecipeCard(
                        index: index,
                        title: recipes[index].recipeTitle,
                        recipeId: recipes[index].recipeId,
                        image: recipes[index].img1,
                        onTap: () {
                          print("66666666666666666666666666666666666666666");
                          print(recipes[index].recipeId);
                          print(recipes[index].recipeTitle);
                          print("66666666666666666666666666666666666666666");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeView(
                                  recipeid: recipes[index].recipeId,
                                  isFromMealPlan: false,
                                  cookbook: "",
                                ),
                              ));
                        },
                      );
                    },
                  ),
                )
              : const Text("Loading ..."),
        ],
      ),
    );
  }
}
