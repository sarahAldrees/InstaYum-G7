import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/widget/meal_plan/horizontal_day_list.dart';
import 'package:instayum/widget/profile/profile.dart';

import 'meal_grid_view.dart';
import 'meal_title.dart';

class AddNewMealPlan extends StatefulWidget {
  String? typeOfMeal;
  String day = 'SUN';
  AddNewMealPlan(this.typeOfMeal, this.day);
  @override
  AddNewMealPlanState createState() => AddNewMealPlanState();
}

class AddNewMealPlanState extends State<AddNewMealPlan> {
  static int activeStepIndex = 0;
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => changeWeekday("SUN"));

    //  MealPlansService.deleteEmptyMealPlans();

    //we call the method here to get the data immediately when init the page.
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static List<List<String>> sunMealPlan = [
    [
      "", //recipe title
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];
  static List<List<String>> monMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];
  static List<List<String>> tueMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];

  static List<List<String>> wedMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];
  static List<List<String>> thuMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];
  static List<List<String>> friMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];
  static List<List<String>> satMealPlan = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];

  static List<List<String>> mealInformation = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];

  static List<List<String>> initiateMealInformation = [
    [
      "",
      "Breakfast",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Lunch",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ],
    [
      "",
      "Dinner",
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95"
    ]
  ];

  static getRecipeIDAfterAddRecipe({String? day, String? typeOfMeal}) {
    print("i am in getRecipeIDAfterAddRecipe");
    print(day);
    print(typeOfMeal);
    String recipeImage = "";
    String recipeTitle = "";
    List<String> oneDayMeals = [];
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String recipeID = "";
    firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        // .doc(MealPlansService.mealPlanID)
        // .collection(day!)
        .doc(typeOfMeal)
        .get()
        .then((snapshot) {
      recipeID = snapshot.data()!["recipe_id"];
      print("9999999999999999999999999999999999999999999999999999");
      print(recipeID);
      print("9999999999999999999999999999999999999999999999999999");
      FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeID)
          .snapshots()
          .listen((recipeData) {
        print("11111111111111111111111111111111111111111111");
        print(recipeData.data()!["recipe_title"]);
        print(recipeData.data()!["img1"]);

        recipeTitle = recipeData.data()!["recipe_title"];
        recipeImage = recipeData.data()!["img1"];
        print("11111111111111111111111111111111111111111111");
        // String dayAndTypeOfMeal = day + "-" + typeOfMeal!;
        oneDayMeals = [
          // dayAndTypeOfMeal,
          recipeData.data()!["recipe_title"],
          typeOfMeal!,
          recipeData.data()!["img1"]
        ];

        switch (day) {
          case "SUN":
            {
              switch (typeOfMeal) {
                case "Breakfast":
                  {
                    sunMealPlan[0] = oneDayMeals;
                  }
                  break;
                case "Lunch":
                  {
                    sunMealPlan[1] = oneDayMeals;
                  }
                  break;
                case "Dinner":
                  {
                    sunMealPlan[2] = oneDayMeals;
                  }
                  break;
              }
            }
            break;

          case "MON":
            {
              switch (typeOfMeal) {
                case "Breakfast":
                  {
                    monMealPlan[0] = oneDayMeals;
                  }
                  break;
                case "Lunch":
                  {
                    monMealPlan[1] = oneDayMeals;
                  }
                  break;
                case "Dinner":
                  {
                    monMealPlan[2] = oneDayMeals;
                  }
                  break;
              }
            }
            break;
          case "TUE":
            switch (typeOfMeal) {
              case "Breakfast":
                {
                  tueMealPlan[0] = oneDayMeals;
                }
                break;
              case "Lunch":
                {
                  tueMealPlan[1] = oneDayMeals;
                }
                break;
              case "Dinner":
                {
                  tueMealPlan[2] = oneDayMeals;
                }
                break;
            }
            break;
          case "WED":
            switch (typeOfMeal) {
              case "Breakfast":
                {
                  wedMealPlan[0] = oneDayMeals;
                }
                break;
              case "Lunch":
                {
                  wedMealPlan[1] = oneDayMeals;
                }
                break;
              case "Dinner":
                {
                  wedMealPlan[2] = oneDayMeals;
                }
                break;
            }
            break;
          case "THU":
            switch (typeOfMeal) {
              case "Breakfast":
                {
                  thuMealPlan[0] = oneDayMeals;
                }
                break;
              case "Lunch":
                {
                  thuMealPlan[1] = oneDayMeals;
                }
                break;
              case "Dinner":
                {
                  thuMealPlan[2] = oneDayMeals;
                }
                break;
            }
            break;
          case "FRI":
            switch (typeOfMeal) {
              case "Breakfast":
                {
                  friMealPlan[0] = oneDayMeals;
                }
                break;
              case "Lunch":
                {
                  friMealPlan[1] = oneDayMeals;
                }
                break;
              case "Dinner":
                {
                  friMealPlan[2] = oneDayMeals;
                }
                break;
            }
            break;
          case "SAT":
            switch (typeOfMeal) {
              case "Breakfast":
                {
                  satMealPlan[0] = oneDayMeals;
                }
                break;
              case "Lunch":
                {
                  satMealPlan[1] = oneDayMeals;
                }
                break;
              case "Dinner":
                {
                  satMealPlan[2] = oneDayMeals;
                }
                break;
            }
            break;
        }
      });
    });
  }

  static String weekday = "SUN";
  void changeWeekday(String newDay) {
    setState(() {
      weekday = newDay;
      switch (weekday) {
        case "SUN":
          {
            mealInformation = sunMealPlan;
          }
          break;
        case "MON":
          {
            mealInformation = monMealPlan;
          }
          break;
        case "TUE":
          {
            mealInformation = tueMealPlan;
          }
          break;
        case "WED":
          {
            mealInformation = wedMealPlan;
          }
          break;
        case "THU":
          {
            mealInformation = thuMealPlan;
          }
          break;
        case "FRI":
          {
            mealInformation = friMealPlan;
          }
          break;
        case "SAT":
          {
            mealInformation = satMealPlan;
          }
          break;
      }
    });
    print("in add new meal plan the day issssssssssssssssssssss:");
    print("changed, $weekday");
  }
}
