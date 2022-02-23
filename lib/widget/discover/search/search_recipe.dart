import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/recipe_title.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class SearchRecipe extends StatelessWidget {
  SearchRecipe({Key? key, this.recipes = const []}) : super(key: key);
  final List<DocumentSnapshot> recipes;

  // final FollowUserService followUserService = FollowUserService();

  @override
  Widget build(BuildContext context) {
    // List<DocumentSnapshot> list = users;
    // print('users list: $list');
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
            print('recipeId: $rid recipe: ${recipe.recipeTitle}');

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (conetxt) => RecipeView(recipeid: rid),
                ));
          },
        );
      },
    );
  }
}
