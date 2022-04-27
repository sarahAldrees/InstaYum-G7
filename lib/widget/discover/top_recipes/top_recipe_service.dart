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
      print("Enter the reset counter if ");
      firebaseFirestore.collection("recipes").get().then((recipes) {
        recipes.docs.forEach((recipe) {
          if (recipe.data()["weeklyBookmarkCount"] >= 1) {
            print("weeklyBookmarkCount is >= 1");
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

  // List<Recipe> fetchAndCalculateTopRecipes(
  //     //List<DocumentSnapshot> allRecipes
  //     ) {
  //   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   allRecipesData.clear();
  //   // DateTime now = DateTime.now();
  //   int countTheNumberOfFethedTrendingRecipes = 0;
  //   // List<Recipe> recpiesList = [];
  //   DateTime? date;
  //   date = DateTime.now();
  //   print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
  //   print(date.weekday);
  //   print(date.day);
  //   print(date.hour);
  //   print(date.minute);
  //   print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");

  //   if (date.weekday == 1) {
  //     //&& date.hour == 23 && date.minute == 30
  //     // the question is if no one open the discover page at that time what will happen?

  //     // maybe we can put a range for one hour we will not calculate the bookmarked form example from 11PM - 12 by just deleting the date.minute
  //     print("Enter the reset counter if ");
  //     firebaseFirestore.collection("recipes").get().then((recipes) {
  //       recipes.docs.forEach((recipe) {
  //         if (recipe.data()["weeklyBookmarkCount"] >= 1) {
  //           print("weeklyBookmarkCount is >= 1");
  //           firebaseFirestore
  //               .collection("recipes")
  //               .doc(recipe.id)
  //               .update({"weeklyBookmarkCount": 0});
  //         }
  //       });
  //     });
  //   }
  //   firebaseFirestore
  //       .collection('recipes')
  //       // .where('is_public_recipe', isEqualTo: true)
  //       .orderBy('weeklyBookmarkCount', descending: true)
  //       .get()
  //       .then((recipesSnapshot) {
  //     // if (allRecipes.isNotEmpty) {
  //     for (var recipe in recipesSnapshot.docs) {
  //       Map<String, dynamic> _data = recipe.data() as Map<String, dynamic>;
  //       Recipe _recp = Recipe.fromJson(_data);

  //       if (countTheNumberOfFethedTrendingRecipes < 10 &&
  //           _recp.isPublicRecipe!) {
  //         countTheNumberOfFethedTrendingRecipes++;

  //         //   _recp.recipeId = recipe.id;
  //         allRecipesData.add(_recp);
  //       } else if (countTheNumberOfFethedTrendingRecipes == 10) {
  //         return allRecipesData;
  //       }
  //     }
  //   });
  //   return allRecipesData;
  // }

  /// }
  // return allRecipesData;

  // for (var recipe in allRecipes) {
  //   Map<String, dynamic> _data = recipe.data() as Map<String, dynamic>;
  //   Recipe _recp = Recipe.fromJson(_data);

  //   List? _bookMarksList = _data['weeklyBookmarks'] as List?;
  //   int _bookmarkCount = 0;

  //   //check weekly bookmarks count
  //   if (_bookMarksList != null) {
  //     if (_bookMarksList.isNotEmpty) {
  //       //get current week start date
  //       DateTime currentWeek = now.subtract(Duration(days: now.weekday));

  //       print("22222222222222222222222222222222222222222222");
  //       print("now.weekday");
  //       print(now.weekday);
  //       print(now.weekday + 1);
  //       print(now.weekday + 2);
  //       print(now.weekday + 3);
  //       print(now.weekday + 4);
  //       print(now.weekday + 5);
  //       print(now.weekday + 6);
  //       print(now.weekday + 7);
  //       print("-----------------------------------------------");
  //       print(now.subtract(Duration(days: now.weekday)));
  //       print(now.subtract(Duration(days: now.weekday + 1)));
  //       print(now.subtract(Duration(days: now.weekday + 2)));
  //       print(now.subtract(Duration(days: now.weekday + 3)));
  //       print(now.subtract(Duration(days: now.weekday + 4)));
  //       print(now.subtract(Duration(days: now.weekday + 5)));
  //       print(now.subtract(Duration(days: now.weekday + 6)));
  //       print(now.subtract(Duration(days: now.weekday + 7)));

  //       print("current week is: ");
  //       print(currentWeek);
  //       print("22222222222222222222222222222222222222222222");

  //       for (int b = 0; b < _bookMarksList.length; b++) {
  //         Timestamp? _timestamp = _bookMarksList[b]["timestamp"];

  //         if (_timestamp != null) {
  //           DateTime _dateTime = _timestamp.toDate();
  //           if (_dateTime.isAfter(currentWeek)) {
  //             _bookmarkCount++;
  //           }
  //         }
  //       }
  //     }
  //   }

  //   _recp.weeklyBookmarkCount = _bookmarkCount;
  //   _recp.recipeId = recipe.id;
  //   allRecipesData.add(_recp);
  // }

  // // check bookmarks count of each recipe
  // for (int i = 0; i < 0; i++) {
  //   String _rid = "tbsXMQVLryYrUmfVlxbL"; // _allRecipesData[i].recipeId;
  //   await firestoreInstance
  //       .collection('recipes')
  //       .doc(_rid)
  //       .collection("bookmarks")
  //       //add time condition
  //       .get()
  //       .then((bookmarksSnapshot) {
  //     print("Bookmarks: ${bookmarksSnapshot.docs.length}");
  //     // int _recIndex = _allRecipesData.indexWhere((e) => e.recipeId == _rid);
  //     _allRecipesData[i].weeklyBookmarkCount = bookmarksSnapshot.docs.length;
  //   });
  // }

  // Sort by weekly bookmark count
  // allRecipesData.sort(
  //   (a, b) {
  //     int counta = a.weeklyBookmarkCount ?? 0;
  //     int countb = b.weeklyBookmarkCount ?? 0;
  //     int compare = countb.compareTo(counta);
  //     return compare;
  //   },
  // );

  // return allRecipesData;
  // }
}
