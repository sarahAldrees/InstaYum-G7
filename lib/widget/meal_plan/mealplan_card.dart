import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/widget/meal_plan/mealplan_service.dart';
import 'package:instayum/widget/meal_plan/view_mealplan.dart';

import 'package:instayum/widget/profile/circular_loader.dart';

class MealPlanCard extends StatefulWidget {
  String? mealplanTitle;
  String? mealplanID;
  bool isPinned;
  String? anotherUserID;
  bool? isFromUserProfileView = false;
  List<List<String>>? sunMealPlan;
  List<List<String>>? monMealPlan;
  List<List<String>>? tueMealPlan;
  List<List<String>>? wedMealPlan;
  List<List<String>>? thuMealPlan;
  List<List<String>>? friMealPlan;
  List<List<String>>? satMealPlan;

  MealPlanCard(
      {this.mealplanTitle,
      this.mealplanID,
      required this.isPinned,
      this.anotherUserID,
      this.isFromUserProfileView,
      this.sunMealPlan,
      this.monMealPlan,
      this.tueMealPlan,
      this.wedMealPlan,
      this.thuMealPlan,
      this.friMealPlan,
      this.satMealPlan});

  @override
  State<MealPlanCard> createState() => MealPlanCardState();
}

List<List<String>> sunMealPlan = [
  [
    "", //recipe title
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];
List<List<String>> monMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];
List<List<String>> tueMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];

List<List<String>> wedMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];
List<List<String>> thuMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];
List<List<String>> friMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];
List<List<String>> satMealPlan = [
  [
    "",
    "Breakfast",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Lunch",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ],
  [
    "",
    "Dinner",
    "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95",
    "" //id
  ]
];

List<String> weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
List<String> typeOfMeals = ["Breakfast", "Lunch", "Dinner"];

class MealPlanCardState extends State<MealPlanCard> {
  showAlertDialogUnpinConfirmationMessage(BuildContext context) {
    // set up the button
    Widget okButton = RaisedButton(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("Yes"),
        onPressed: () {
          MealPlansService.updatePinConditionToFalse(widget.mealplanID);
          setState(() {
            widget.isPinned = false;
          });

          setState(() {});
          Navigator.of(context).pop(); // to close the alert dialog
        });

    Widget cancelButton = RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: () {
          Navigator.of(context)
              .pop(); //just close the alert dialog and stay in the same page
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "Unpin this meal plan",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      content: Text(
        "Are you sure?",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getMealPlanRecipes() {
    print("####################################");
    print(widget.mealplanID);
    print(widget.mealplanTitle);
    print("####################################");
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String recipeID = "";
    List<String> oneDayMeal = [];
    for (int i = 0; weekdays.length > i; i++) {
      for (int j = 0; typeOfMeals.length > j; j++) {
        firebaseFirestore
            .collection("users")
            .doc(AppGlobals.userId)
            .collection("mealPlans")
            .doc(widget.mealplanID)
            .collection(weekdays[i])
            .doc(typeOfMeals[j])
            .get()
            .then((snapshot) {
          recipeID = "";
          if (snapshot.exists) {
            recipeID = snapshot.data()!["recipe_id"];
            print("2222222222222222222222222222222222222");
            print("recipe id is: ");
            print(recipeID);
          }
          // }).then((value) async {
          if (recipeID != "") {
            // oneDayMeal = getOneDayMeals(recipeID, typeOfMeals[j]);
            print("333333333333333333333333333333333333333");
            print("recipe id is not null");
            FirebaseFirestore.instance
                .collection("recipes")
                .doc(recipeID)
                .get()
                .then((recipeData) {
              oneDayMeal = [
                recipeData.data()!["recipe_title"],
                typeOfMeals[j],
                recipeData.data()!["img1"],
                snapshot.data()!["recipe_id"]
              ];
            }).then((value) {
              switch (weekdays[i]) {
                case "SUN":
                  {
                    switch (typeOfMeals[j]) {
                      case "Breakfast":
                        {
                          sunMealPlan[0] = oneDayMeal;
                          print("4444444444444444444444444444444");
                          print("Sunday breakfast");
                          print(oneDayMeal[3]);
                        }
                        break;
                      case "Lunch":
                        {
                          sunMealPlan[1] = oneDayMeal;
                          print("4444444444444444444444444444444");
                          print("Sunday Lunch");
                        }
                        break;
                      case "Dinner":
                        {
                          sunMealPlan[2] = oneDayMeal;
                        }
                        break;
                    }
                  }
                  break;
                case "MON":
                  {
                    switch (typeOfMeals[j]) {
                      case "Breakfast":
                        {
                          monMealPlan[0] = oneDayMeal;
                          print("4444444444444444444444444444444");
                          print("Monday Breakfast is ");
                          print(monMealPlan[0]);

                          print("onDayMeal in monday Breakfast is: ");
                          print(oneDayMeal);
                        }
                        break;
                      case "Lunch":
                        {
                          monMealPlan[1] = oneDayMeal;
                        }
                        break;
                      case "Dinner":
                        {
                          monMealPlan[2] = oneDayMeal;
                        }
                        break;
                    }
                  }
                  break;
                case "TUE":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        tueMealPlan[0] = oneDayMeal;
                      }
                      break;
                    case "Lunch":
                      {
                        tueMealPlan[1] = oneDayMeal;
                      }
                      break;
                    case "Dinner":
                      {
                        tueMealPlan[2] = oneDayMeal;
                      }
                      break;
                  }
                  break;
                case "WED":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        wedMealPlan[0] = oneDayMeal;
                      }
                      break;
                    case "Lunch":
                      {
                        wedMealPlan[1] = oneDayMeal;
                      }
                      break;
                    case "Dinner":
                      {
                        wedMealPlan[2] = oneDayMeal;
                      }
                      break;
                  }
                  break;
                case "THU":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        thuMealPlan[0] = oneDayMeal;
                      }
                      break;
                    case "Lunch":
                      {
                        thuMealPlan[1] = oneDayMeal;
                      }
                      break;
                    case "Dinner":
                      {
                        thuMealPlan[2] = oneDayMeal;
                      }
                      break;
                  }
                  break;
                case "FRI":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        friMealPlan[0] = oneDayMeal;
                      }
                      break;
                    case "Lunch":
                      {
                        friMealPlan[1] = oneDayMeal;
                      }
                      break;
                    case "Dinner":
                      {
                        friMealPlan[2] = oneDayMeal;
                      }
                      break;
                  }
                  break;
                case "SAT":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        satMealPlan[0] = oneDayMeal;
                      }
                      break;
                    case "Lunch":
                      {
                        satMealPlan[1] = oneDayMeal;
                      }
                      break;
                    case "Dinner":
                      {
                        satMealPlan[2] = oneDayMeal;
                      }
                      break;
                  }
                  break;
              }
            });
          }
        });
      }
    }
  }

  showAlertDialogTransferMealplan(BuildContext context) {
    // set up the button
    Widget yesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () {
        MealPlansService.makePinnedMealplanAlwaysUp();

        // MealPlansService.updatePinConditionToTrue(
        //     MealPlansService.pinedMealPlanID);

        getMealPlanRecipes();

        final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

        DateTime timestamp = DateTime.now();

        var newMealplanID;

        newMealplanID = firebaseFirestore
            .collection('users')
            .doc(AppGlobals.userId)
            .collection('mealPlans')
            .add({
          "mealplan_title": widget.mealplanTitle,
          "is_public_mealplan": false,
          "is_pinned": false,
          "timestamp": timestamp
        }).then((value) {
          String recipeID = "";
          List<String> oneDayMeal = [];
          for (int i = 0; weekdays.length > i; i++) {
            for (int j = 0; typeOfMeals.length > j; j++) {
              firebaseFirestore
                  .collection("users")
                  .doc(AppGlobals.userId)
                  .collection("mealPlans")
                  .doc(widget.mealplanID)
                  .collection(weekdays[i])
                  .doc(typeOfMeals[j])
                  .get()
                  .then((snapshot) {
                recipeID = "";
                if (snapshot.exists) {
                  recipeID = snapshot.data()!["recipe_id"];
                  print("2222222222222222222222222222222222222");
                  print("recipe id is: ");
                  print(recipeID);
                }
                // }).then((value) async {
                if (recipeID != "") {
                  // oneDayMeal = getOneDayMeals(recipeID, typeOfMeals[j]);
                  print("333333333333333333333333333333333333333");
                  print("recipe id is not null");
                  FirebaseFirestore.instance
                      .collection("recipes")
                      .doc(recipeID)
                      .get()
                      .then((recipeData) {
                    oneDayMeal = [
                      recipeData.data()!["recipe_title"],
                      typeOfMeals[j],
                      recipeData.data()!["img1"],
                      snapshot.data()!["recipe_id"]
                    ];
                  }).then((value) {
                    switch (weekdays[i]) {
                      case "SUN":
                        {
                          switch (typeOfMeals[j]) {
                            case "Breakfast":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("SUN")
                                    .doc("Breakfast")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Breakfast"
                                });
                              }
                              break;
                            case "Lunch":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("SUN")
                                    .doc("Lunch")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Lunch"
                                });
                              }
                              break;
                            case "Dinner":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("SUN")
                                    .doc("Dinner")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Dinner"
                                });
                              }
                              break;
                          }
                        }
                        break;
                      case "MON":
                        {
                          switch (typeOfMeals[j]) {
                            case "Breakfast":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("MON")
                                    .doc("Breakfast")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Breakfast"
                                });
                              }
                              break;
                            case "Lunch":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("MON")
                                    .doc("Lunch")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Lunch"
                                });
                              }
                              break;
                            case "Dinner":
                              {
                                firebaseFirestore
                                    .collection('users')
                                    .doc(AppGlobals.userId)
                                    .collection('mealPlans')
                                    .doc(newMealplanID)
                                    .collection("MON")
                                    .doc("Dinner")
                                    .set({
                                  "recipe_id": recipeID,
                                  "type_of_meal": "Dinner"
                                });
                              }
                              break;
                          }
                        }
                        break;
                      case "TUE":
                        switch (typeOfMeals[j]) {
                          case "Breakfast":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("TUE")
                                  .doc("Breakfast")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Breakfast"
                              });
                            }
                            break;
                          case "Lunch":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("TUE")
                                  .doc("Lunch")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Lunch"
                              });
                            }
                            break;
                          case "Dinner":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("TUE")
                                  .doc("Dinner")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Dinner"
                              });
                            }
                            break;
                        }
                        break;
                      case "WED":
                        switch (typeOfMeals[j]) {
                          case "Breakfast":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("WED")
                                  .doc("Breakfast")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Breakfast"
                              });
                            }
                            break;
                          case "Lunch":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("WED")
                                  .doc("Lunch")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Lunch"
                              });
                            }
                            break;
                          case "Dinner":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("WED")
                                  .doc("Dinner")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Dinner"
                              });
                            }
                            break;
                        }
                        break;
                      case "THU":
                        switch (typeOfMeals[j]) {
                          case "Breakfast":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("THU")
                                  .doc("Breakfast")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Breakfast"
                              });
                            }
                            break;
                          case "Lunch":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("THU")
                                  .doc("Lunch")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Lunch"
                              });
                            }
                            break;
                          case "Dinner":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("THU")
                                  .doc("Dinner")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Dinner"
                              });
                            }
                            break;
                        }
                        break;
                      case "FRI":
                        switch (typeOfMeals[j]) {
                          case "Breakfast":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("FRI")
                                  .doc("Breakfast")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Breakfast"
                              });
                            }
                            break;
                          case "Lunch":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("FRI")
                                  .doc("Lunch")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Lunch"
                              });
                            }
                            break;
                          case "Dinner":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("FRI")
                                  .doc("Dinner")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Dinner"
                              });
                            }
                            break;
                        }
                        break;
                      case "SAT":
                        switch (typeOfMeals[j]) {
                          case "Breakfast":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("SAT")
                                  .doc("Breakfast")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Breakfast"
                              });
                            }
                            break;
                          case "Lunch":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("SAT")
                                  .doc("Lunch")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Lunch"
                              });
                            }
                            break;
                          case "Dinner":
                            {
                              firebaseFirestore
                                  .collection('users')
                                  .doc(AppGlobals.userId)
                                  .collection('mealPlans')
                                  .doc(newMealplanID)
                                  .collection("SAT")
                                  .doc("Dinner")
                                  .set({
                                "recipe_id": recipeID,
                                "type_of_meal": "Dinner"
                              });
                            }
                            break;
                        }
                        break;
                    }
                  });
                }
              });
            }
          }
        });

        Navigator.of(context).pop();
      },
    );
    Widget noButton = RaisedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Cpoy Meal Plan",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "Are you sure you want to copy this meal plan to your account?",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return

        // build and return the container which is the Tap veiw of meal Plans
        Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child:
          // build card of the meal plan name and the button .
          GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewMealplan(
                isFromUserProfileView: widget.isFromUserProfileView!,
                anotherUserID: widget.anotherUserID,
                mealplanTitle: widget.mealplanTitle,
                mealplanID: widget.mealplanID,
                sunMealPlan: widget.sunMealPlan,
                monMealPlan: widget.monMealPlan,
                tueMealPlan: widget.tueMealPlan,
                wedMealPlan: widget.wedMealPlan,
                thuMealPlan: widget.thuMealPlan,
                friMealPlan: widget.friMealPlan,
                satMealPlan: widget.satMealPlan,
              ),
            ),
          );
        },
        child: Card(
          child: Container(
            height: 90,
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      widget.mealplanTitle!,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  widget.isFromUserProfileView!
                      ? ElevatedButton(
                          child: Text(
                            "Copy meal plan",
                            style: TextStyle(color: Color(0xFFeb6d44)),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () async {
                            showAlertDialogTransferMealplan(context);
                          },
                        )
                      : !widget.isPinned
                          ? IconButton(
                              icon: Icon(
                                Icons.push_pin_outlined,
                              ),
                              iconSize: 30,
                              color: Colors.white,
                              splashColor: Colors.white,
                              onPressed: () {
                                print("######################################");
                                print(widget.mealplanID);
                                print("######################################");

                                appPages()
                                    .showAlertDialogPinConfirmationMessage(
                                        context, widget.mealplanID);

                                // MealPlansService.updatePinConditionToTrue(
                                //     widget.mealplanID);

                                //();
                                // Future.delayed(const Duration(milliseconds: 500),
                                //     () {
                                //   // MealPlansService.updatePinCondition(
                                //   //     widget.mealplanID, true);

                                //   setState(() {});
                                // });
                                // setState(() {
                                //   widget.isPinned = true;
                                // });

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             MyMealplanScreen("", "")));
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.push_pin,
                              ),
                              iconSize: 30,
                              color: Colors.white,
                              splashColor: Colors.white,
                              onPressed: () {
                                showAlertDialogUnpinConfirmationMessage(
                                    context);
                                // MealPlansService.updatePinConditionToFalse(
                                //     widget.mealplanID);
                                // setState(() {
                                //   widget.isPinned = false;
                                // });
                              },
                            )
                  // ElevatedButton(
                  //    //child:
                  //   // Text(
                  //   //   "View Plan",
                  //   //   style: TextStyle(color: Color(0xFFeb6d44)),
                  //   // ),
                  //   // style: ElevatedButton.styleFrom(
                  //   //   primary: Colors.white,
                  //   // ),
                  //   onPressed: () {
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //       builder: (context) => ViewMealplan(
                  //     //             mealplanTitle: mealplanTitle,
                  //     //             mealplanID: mealplanID,
                  //     //             sunMealPlan: sunMealPlan,
                  //     //             monMealPlan: monMealPlan,
                  //     //             tueMealPlan: tueMealPlan,
                  //     //             wedMealPlan: wedMealPlan,
                  //     //             thuMealPlan: thuMealPlan,
                  //     //             friMealPlan: friMealPlan,
                  //     //             satMealPlan: satMealPlan,
                  //     //           )),
                  //     // );
                  //   },
                  // ),
                ]),
          ),
          // change z-axis place of card
          elevation: 3,
          shadowColor: Colors.black,
          margin: EdgeInsets.all(20),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          color: Color(0xFFeb6d44),
        ),
      ),
    );
  }
}
