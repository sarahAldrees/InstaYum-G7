import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/notification_model.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/model/recipe_rating.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/follow_and_notification/notification_api.dart';
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
    int? position,
  }) async {
    Timestamp timestamp = Timestamp.now();
    String? userId = AppGlobals.userId;
    String? recipe_id;
    Random random = new Random();
    int randomNumber = random.nextInt(1000000);

    Recipe recipe = Recipe(
      userId: userId,
      timestamp: timestamp,
      recipeTitle: recipeTitle,
      isPublicRecipe: isPublic,
      cuisine: currentSelectedCuisine,
      category: currentSelectedCategory,
      typeOfMeal: currentSelectedTypeOfMeal,
      position: randomNumber,
      lengthOfIngredients: userIngredients.length,
      lengthOfDirections: userDirections.length,
      bookmarkCounter: 0,
      mealPlanCounter: 0,
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
    RecipeRating recipeRating = RecipeRating(
      numOfReviews: 0,
      sumOfAllRating: 0,
      averageRating: 0.0,
      userAlreadyReview: [],
    );

    //create new collcetion of recipes inside user document to save all of the user's recipes
    await firebaseFirestore
        .collection("recipes")
        .doc(recipe_id)
        .collection("rating")
        .doc("recipeRating")
        .set(
          recipeRating.toJson(),
          // { "sum_of_all_rating": 0,
          // "num_of_reviews": 0,
          // "average_rating": 0.0,
          // "user_already_review": FieldValue.arrayUnion([]), }
        );
    if (isPublic) {
      //send notification to my followers
      await sendNotificationToFollowers(userId,
          recipeId: recipe_id, recipeTitle: recipeTitle);
    }
  }

  static Future sendNotificationToFollowers(String? userId,
      {String? recipeId, String? recipeTitle}) async {
    List<String?> allTokens = [];
    List<String> allIds = [];

    UserModel currentUser = UserModel().getCurrentUserData();
    String name = '${currentUser.username}';
    String desc = 'added new recipe';
    Timestamp timestamp = Timestamp.now();

    NotificationModel notification = NotificationModel(
      date: timestamp,
      title1: name,
      description: desc,
      title2: recipeTitle,
      type: 'recipe',
      userName: name,
      recipeId: recipeId,
      userId: currentUser.userId,
      userImage: currentUser.imageUrl,
    );

    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('users/$userId/followers').get();

    print('userFollowers: ${querySnapshot.docs.length}');

    // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //for a specific field
    // final allTokens = querySnapshot.docs.map((doc) => doc.get('pushToken')).toList();

    if (querySnapshot.docs.isNotEmpty) {
      allIds.clear();
      allTokens.clear();

      // Get userIds from user followers docs list
      for (var doc in querySnapshot.docs) {
        allIds.add(doc.id);
      }
      print('allIds: ${allIds.length}');

      if (allIds.isNotEmpty) {
        // get pushToken of each user / save and send notification
        for (String uid in allIds) {
          firebaseFirestore.collection('users').doc("$uid").get().then(
            (document) {
              Map data = document.data() as Map<String, dynamic>;
              String token = data['pushToken'];
              // allTokens.add(data['pushToken']);

              //send notification to follower
              NotificationApi.SendNotification(
                token: token,
                title1: name,
                title2: recipeTitle,
                recipeId: recipeId,
                timestamp: timestamp,
                type: 'recipe',
                desc: desc,
                name: name,
                userId: currentUser.userId,
                imageUrl: currentUser.imageUrl,
                body: '$name $desc $recipeTitle',
              );
            },
          );

          // Add notification to other user notifications list
          firebaseFirestore
              .collection('users/$uid/notifications')
              .add(notification.toJson());
          // .catchError((error) => print('Notifications failed: $error'));

        }
      }
    }
  }

  Future sendNotificationToAuthor(String? recipeId, String? username) async {
    String? userId, token, recipeTitle;

    // get the user id of the recipe's author
    await firebaseFirestore
        .collection("recipes")
        .doc(recipeId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data()!;
      userId = data['user_id'];
      recipeTitle = data['recipe_title'];
    });

    //get the user's push token
    await firebaseFirestore
        .collection("users")
        .doc(userId)
        .get()
        .then((snapshot) {
      Map data = snapshot.data()!;
      token = data['pushToken'];
    });

    UserModel currentUser = UserModel().getCurrentUserData();
    String name = '${currentUser.username}';
    String desc = 'commented on your recipe';
    Timestamp timestamp = Timestamp.now();

    NotificationModel notification = NotificationModel(
      date: timestamp,
      title1: name,
      description: desc,
      title2: '$recipeTitle',
      type: 'comment',
      recipeId: recipeId,
      userId: currentUser.userId,
      userName: currentUser.username,
      userImage: currentUser.imageUrl,
    );

    firebaseFirestore
        .collection('users/$userId/notifications')
        .add(notification.toJson())
        .catchError((error) => print('Notifications failed: $error'));

    NotificationApi.SendNotification(
      token: token,
      title1: username,
      title2: recipeTitle,
      recipeId: recipeId,
      timestamp: timestamp,
      desc: desc,
      name: name,
      type: 'comment',
      userId: currentUser.userId,
      imageUrl: currentUser.imageUrl,
      body: '$username $desc $recipeTitle',
    );
  }
}
