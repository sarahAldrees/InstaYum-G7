import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/widget/pickers/cookbook_image_picker.dart';

import 'mealplan_card.dart';

class MealPlansService {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String? mealPlanID;
  static bool hasMealPlanCollection = false;
  static String chosenMealDay = 'SUN';
  static int countNumOfRecipes = 0;

  static deleteEmptyMealPlans() async {
    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc.data()["mealplan_title"] == "delete") {
          firebaseFirestore
              .collection("users")
              .doc(AppGlobals.userId)
              .collection("mealPlans")
              .doc(doc.id)
              .delete();
        }
      });
    });
  }

  static Future addMealPlanDatabase() async {
    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .add({"mealplan_title": "delete"}).then(
            (value) => mealPlanID = value.id);
  }

  static Future addRecipeToMealPlanDatabase(
      {String? mealDay, String? mealPlanTypeOfMeal, String? recipeID}) async {
    countNumOfRecipes++;
    chosenMealDay = mealDay!;

    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(mealPlanID)
        .collection(mealDay)
        .doc(mealPlanTypeOfMeal)
        .set({"type_of_meal": mealPlanTypeOfMeal, "recipe_id": recipeID});
  }

  static Future deleteRecipeFromMealPlanDatabase(
      String? mealDay, String? mealPlanTypeOfMeal, String? recipeID) async {
    countNumOfRecipes--;

    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(mealPlanID)
        .collection(mealDay!)
        .doc(mealPlanTypeOfMeal)
        .delete();
  }

  static Future<bool> checkRecipeIsAdded(
      {String? mealDay, String? mealPlanTypeOfMeal, String? recipeID}) async {
    DocumentSnapshot specificMealPlan = await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(mealPlanID)
        .collection(mealDay!)
        .doc(mealPlanTypeOfMeal)
        .get();

    if (specificMealPlan.exists) {
      Map<String, dynamic>? data =
          specificMealPlan.data() as Map<String, dynamic>?;

      // You can then retrieve the value from the Map like this:
      var recipe_id = data!['recipe_id'];
      if (recipe_id == recipeID) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future addMealPlanTitleAndStatus(
      String? mealPlanTitle, bool isPublic) async {
    Timestamp? timestamp = Timestamp.now();

    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(mealPlanID)
        .set({
      'mealplan_title': mealPlanTitle,
      "is_public_mealplan": isPublic,
      "timestamp": timestamp,
      "is_pinned": false
    });
  }

  static Future updatePinConditionToTrue(String mealplanID) async {
    //and make all other mealplans the pin condition is false;
    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        firebaseFirestore
            .collection("users")
            .doc(AppGlobals.userId)
            .collection("mealPlans")
            .doc(doc.id)
            .update({"is_pinned": false});
      });
    }).then((value) async {
      Timestamp? timestamp = Timestamp.now();

      await firebaseFirestore
          .collection("users")
          .doc(AppGlobals.userId)
          .collection("mealPlans")
          .doc(mealplanID)
          .update({"timestamp": timestamp, "is_pinned": true});
    });
  }

  static Future updatePinConditionToFalse(String? mealplanID) async {
    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(mealplanID)
        .update({"is_pinned": false});
  }

  static Future makePinnedMealplanAlwaysUp() async {
    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        if (doc.data()["is_pinned"]) {
          updatePinConditionToTrue(doc.id);
        }
      });
    });
  }
}
