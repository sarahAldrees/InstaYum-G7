import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/meal_plan/horizontal_day_list.dart';

import 'add_new_mealplan.dart';
import 'choose_meal_recipes.dart';
import 'meal_grid_view.dart';

class ViewMealplan extends StatefulWidget {
  String? mealplanTitle;
  String? mealplanID;
  String? anotherUserID;
  bool isFromUserProfileView = false;
  List<List<String>>? sunMealPlan;
  List<List<String>>? monMealPlan;
  List<List<String>>? tueMealPlan;
  List<List<String>>? wedMealPlan;
  List<List<String>>? thuMealPlan;
  List<List<String>>? friMealPlan;
  List<List<String>>? satMealPlan;

  ViewMealplan(
      {this.mealplanTitle,
      this.mealplanID,
      required this.isFromUserProfileView,
      this.anotherUserID,
      this.sunMealPlan,
      this.monMealPlan,
      this.tueMealPlan,
      this.wedMealPlan,
      this.thuMealPlan,
      this.friMealPlan,
      this.satMealPlan});

  @override
  State<StatefulWidget> createState() => ViewMealplanState();
}

class ViewMealplanState extends State<ViewMealplan> {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMealPlanRecipes());

    //we call the method here to get the data immediately when init the page.
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<List<String>> mealInformation = [
    [
      "", //title
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

  List<String> weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
  List<String> typeOfMeals = ["Breakfast", "Lunch", "Dinner"];
  //List<MealPlan> mealplansList = [];
  String mealplanId = "";

  List<List<String>> initializationData = [
    //the images need to be changed
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

  List<List<String>> sunMealPlan = [
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
  List<List<String>> monMealPlan = [
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
  List<List<String>> tueMealPlan = [
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

  List<List<String>> wedMealPlan = [
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
  List<List<String>> thuMealPlan = [
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
  List<List<String>> friMealPlan = [
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
  List<List<String>> satMealPlan = [
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

  List<List<String>> initiateMealInformation = [
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

//the 2 second part of sepreate operation
  getMealPlanRecipes() {
    print("####################################");
    print(widget.mealplanID);
    print(widget.mealplanTitle);
    print("####################################");

    String? userID = AppGlobals.userId;

    setState(() {
      userID = widget.isFromUserProfileView
          ? widget.anotherUserID
          : AppGlobals.userId;

      print('0-0-0----0-0-0-0-0-0-0-0-');
      print(userID);
      print('0-0-0----0-0-0-0-0-0-0-0-');
    });
    String recipeID = "";
    List<String> oneDayMeal = [];
    for (int i = 0; weekdays.length > i; i++) {
      for (int j = 0; typeOfMeals.length > j; j++) {
        firebaseFirestore
            .collection("users")
            .doc(userID)
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
                recipeData.data()!["img1"]
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

  String weekday = "SUN";

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

    print("changed, $weekday");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFeb6d44),
        title: Text(widget.mealplanTitle!),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          HorizontalDayList(changeWeekday, false),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              // the white space
              child: MealGridView(
                  mealList:
                      mealInformation), // we call the gird view to present them in the white space
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [BoxShadow(blurRadius: 10.0)]),
            ),
          ),
        ],
      ),
    );
  }
}
