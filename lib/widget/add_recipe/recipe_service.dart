import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/pickers/recipe_image_picker.dart';

class RecipeService {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future addRecipeToDatabase({
    // String? userId,
    String? recipeTitle,
    String? currentSelectedTypeOfMeal,
    String? currentSelectedCategory,
    String? currentSelectedCuisine,
    bool isPublic = false,
    List<String?> userIngredients = const [],
    List<String?> userDirections = const [],
  }) async {
    Timestamp timestamp = Timestamp.now();
    String? userId = AppGlobals.userId;
    String? recipe_id;

    Recipe recipe = Recipe(
      userId: userId,
      timestamp: timestamp,
      recipeTitle: recipeTitle,
      isPublicRecipe: isPublic,
      cuisine: currentSelectedCuisine,
      category: currentSelectedCategory,
      typeOfMeal: currentSelectedTypeOfMeal,
      lengthOfIngredients: userIngredients.length,
      lengthOfDirections: userDirections.length,
    );

    // create a new recipe inside collcetion of recipes
    await firebaseFirestore
        .collection("recipes")
        // .doc(recipe_id)
        // .set(
        .add(recipe.toJson())
        .then((value) {
      recipe_id = value.id;
    });
    print('recipeid: $recipe_id');

    // to save the ingredients
    int ci = 0;
    for (var ing in userIngredients) {
      ci++;
      await firebaseFirestore
          .collection("recipes")
          .doc(recipe_id)
          .update({'ing$ci': ing});
    }
    // to save the directions
    int cd = 0;
    for (var dir in userDirections) {
      cd++;
      await firebaseFirestore
          .collection("recipes")
          .doc(recipe_id)
          .update({'dir$cd': '${cd}- ' + dir!});
    }
    // to save the classification
    // String recipe_image_url = RecipeImagePickerState.uploadedFileURL;
    //if (recipe_image_url == null) recipe_image_url = 'noImageUrl';

    if (RecipeImagePickerState.imagesURLs.isEmpty) {
      await firebaseFirestore.collection("recipes").doc(recipe_id).update({
        'img1': "noImageUrl",
        'image_count': 0,
      });
    } else {
      int countImage = 0;
      for (var url in RecipeImagePickerState.imagesURLs) {
        print(url);
        countImage++;
        await firebaseFirestore.collection("recipes").doc(recipe_id).update({
          'img$countImage': url,
          'image_count': countImage,
        });
      }
    }

    //--------------------creat collection of reating with zeros----------
    // RecipeRating recipeRating = RecipeRating(
    //   numOfReviews: 0,
    //   sumOfAllRating: 0,
    //   averageRating: 0.0,
    //   userAlreadyReview: [],
    // );

    // create new collcetion of recipes inside user document to save all of the user's recipes
    // await firebaseFirestore
    //     .collection("recipes")
    //     .doc(recipe_id)
    //     .collection("rating")
    //     .doc("recipeRating")
    //     .set(
    //       recipeRating.toJson(),
    //       // { "sum_of_all_rating": 0,
    //       // "num_of_reviews": 0,
    //       // "average_rating": 0.0,
    //       // "user_already_review": FieldValue.arrayUnion([]), }
    //     );
  }
}
