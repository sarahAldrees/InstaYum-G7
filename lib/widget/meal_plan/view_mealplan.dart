import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/meal_plan/horizontal_day_list.dart';
import 'package:instayum/widget/meal_plan/my_mealplans_screen.dart';

import '../../main_pages.dart';
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
      "Breakfast", //type of meal
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95", //image
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
  String mealplanId = "";

  List<List<String>> initializationData = [
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

  List<List<String>> initiateMealInformation = [
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

//the 2 second part of sepreate operation
  getMealPlanRecipes() {
    String? userID = AppGlobals.userId;

    setState(() {
      userID = widget.isFromUserProfileView
          ? widget.anotherUserID
          : AppGlobals.userId;
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
          }
          if (recipeID != "") {
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
                          setState(() {
                            sunMealPlan[0] = oneDayMeal;
                          });
                        }
                        break;
                      case "Lunch":
                        {
                          setState(() {
                            sunMealPlan[1] = oneDayMeal;
                          });
                        }
                        break;
                      case "Dinner":
                        {
                          setState(() {
                            sunMealPlan[2] = oneDayMeal;
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
                          setState(() {
                            monMealPlan[0] = oneDayMeal;
                          });
                        }
                        break;
                      case "Lunch":
                        {
                          setState(() {
                            monMealPlan[1] = oneDayMeal;
                          });
                        }
                        break;
                      case "Dinner":
                        {
                          setState(() {
                            monMealPlan[2] = oneDayMeal;
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
                        setState(() {
                          tueMealPlan[0] = oneDayMeal;
                        });
                      }
                      break;
                    case "Lunch":
                      {
                        setState(() {
                          tueMealPlan[1] = oneDayMeal;
                        });
                      }
                      break;
                    case "Dinner":
                      {
                        setState(() {
                          tueMealPlan[2] = oneDayMeal;
                        });
                      }
                      break;
                  }
                  break;
                case "WED":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        setState(() {
                          wedMealPlan[0] = oneDayMeal;
                        });
                      }
                      break;
                    case "Lunch":
                      {
                        setState(() {
                          wedMealPlan[1] = oneDayMeal;
                        });
                      }
                      break;
                    case "Dinner":
                      {
                        setState(() {
                          wedMealPlan[2] = oneDayMeal;
                        });
                      }
                      break;
                  }
                  break;
                case "THU":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        setState(() {
                          thuMealPlan[0] = oneDayMeal;
                        });
                      }
                      break;
                    case "Lunch":
                      {
                        setState(() {
                          thuMealPlan[1] = oneDayMeal;
                        });
                      }
                      break;
                    case "Dinner":
                      {
                        setState(() {
                          thuMealPlan[2] = oneDayMeal;
                        });
                      }
                      break;
                  }
                  break;
                case "FRI":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        setState(() {
                          friMealPlan[0] = oneDayMeal;
                        });
                      }
                      break;
                    case "Lunch":
                      {
                        setState(() {
                          friMealPlan[1] = oneDayMeal;
                        });
                      }
                      break;
                    case "Dinner":
                      {
                        setState(() {
                          friMealPlan[2] = oneDayMeal;
                        });
                      }
                      break;
                  }
                  break;
                case "SAT":
                  switch (typeOfMeals[j]) {
                    case "Breakfast":
                      {
                        setState(() {
                          satMealPlan[0] = oneDayMeal;
                        });
                      }
                      break;
                    case "Lunch":
                      {
                        setState(() {
                          satMealPlan[1] = oneDayMeal;
                        });
                      }
                      break;
                    case "Dinner":
                      {
                        setState(() {
                          satMealPlan[2] = oneDayMeal;
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
//-----------------------------------------------------Delete the meal plan-------------------------

  //----------------------------------DELETE COOKBOOK-----------------------------
  showAlertDialogDeleteMealplan(BuildContext context) {
    // set up the button
    Widget yesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () {
        deleteMealplan();
        setState(() {});
      },
    );
    Widget noButton = RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "No",
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Meal Plan",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "Are you sure you want to delete this plan?",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        noButton,
        yesButton,
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

  void deleteMealplan() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .doc(widget.mealplanID)
        .delete();
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPages()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFeb6d44),
        title: Text(widget.mealplanTitle!),
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    //  Icons.ios_share,
                    size: 30,
                  ),
                  onPressed: () {
                    showAlertDialogDeleteMealplan(context);
                  }),
            ],
          ),
        ],
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
