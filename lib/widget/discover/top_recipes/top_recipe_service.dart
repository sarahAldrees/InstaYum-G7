import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/model/recipe.dart';

class TopRecipeService {
  List<Recipe> allRecipesData = [];

  // add To Weekly Top Bookmarks
  Future<void> addToWeeklyTopBookmarks(
      {String? recipeId, String? userId}) async {
    int? weekly_bookmark_counter;
    if (recipeId != null && userId != null) {
      FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .get()
          .then((recipeDoc) {
        if (recipeDoc.exists) {
          weekly_bookmark_counter = recipeDoc.data()?["weeklyBookmarkCount"];

          weekly_bookmark_counter = weekly_bookmark_counter ?? 0 + 1;

          FirebaseFirestore.instance
              .collection("recipes")
              .doc(recipeId)
              .update({"weeklyBookmarkCount": weekly_bookmark_counter});
        }
      });
    }
  }

  // remove From Weekly Top Bookmarks
  Future<void> removeFromWeeklyTopBookmarks(
      {String? recipeId, String? userId}) async {
    int weekly_bookmark_counter = 0;
    if (recipeId != null && userId != null) {
      FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .get()
          .then((recipeDoc) {
        if (recipeDoc.exists) {
          weekly_bookmark_counter = recipeDoc.data()!["weeklyBookmarkCount"];

          weekly_bookmark_counter = weekly_bookmark_counter - 1;

          FirebaseFirestore.instance
              .collection("recipes")
              .doc(recipeId)
              .update({"weeklyBookmarkCount": weekly_bookmark_counter});
        }
      });
    }
  }

  Future<List<Recipe>> fetchAndCalculateTopRecipes() async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List<Recipe> allRecipesData = [];

    int countTheNumberOfFethedTrendingRecipes = 0;
    DateTime? date;
    date = DateTime.now();

    if (date.weekday == 0 && date.hour == 2) {
      firebaseFirestore.collection("recipes").get().then((recipes) {
        recipes.docs.forEach((recipe) {
          if (recipe.data()["weeklyBookmarkCount"] >= 1) {
            firebaseFirestore
                .collection("recipes")
                .doc(recipe.id)
                .update({"weeklyBookmarkCount": 0});
          }
        });
      });
    }
    firebaseFirestore
        .collection('recipes')
        .orderBy('weeklyBookmarkCount', descending: true)
        .get()
        .then((recipesSnapshot) {
      for (var recipe in recipesSnapshot.docs) {
        Map<String, dynamic> _data = recipe.data() as Map<String, dynamic>;
        Recipe _recp = Recipe.fromJson(_data);
        _recp.recipeId = recipe.id;
        if (countTheNumberOfFethedTrendingRecipes < 10 &&
            _recp.isPublicRecipe!) {
          countTheNumberOfFethedTrendingRecipes++;

          allRecipesData.add(_recp);
        }
      }
    });

    return allRecipesData;
  }
}
