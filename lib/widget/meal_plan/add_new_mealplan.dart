import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/widget/meal_plan/horizontal_day_list.dart';
import 'package:instayum/widget/meal_plan/mealplan_service.dart';
import 'package:instayum/widget/profile/profile.dart';

import 'meal_grid_view.dart';

import 'meal_tile.dart';

class AddNewMealPlan extends StatefulWidget {
  String? typeOfMeal;
  String day = 'SUN';
  AddNewMealPlan(this.typeOfMeal, this.day);
  @override
  AddNewMealPlanState createState() => AddNewMealPlanState();
}

class AddNewMealPlanState extends State<AddNewMealPlan> {
  static int activeStepIndex = 0;
  bool validTitleToSubmit = true;
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => changeWeekday("SUN"));

    MealPlansService.deleteEmptyMealPlans();

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
        .doc(MealPlansService.mealPlanID)
        .collection(day!)
        .doc(typeOfMeal)
        .get()
        .then((snapshot) {
      recipeID = snapshot.data()!["recipe_id"];

      FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeID)
          .snapshots()
          .listen((recipeData) {
        recipeTitle = recipeData.data()!["recipe_title"];
        recipeImage = recipeData.data()!["img1"];
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

  static String weekday = MealPlansService.chosenMealDay;
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

  static bool isAddMealplanNullFields() {
    if (mealplanTitleTextFieldController.value.text == "") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkMealPlanName(String mealplanTitle) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .where('mealplan_title', isEqualTo: mealplanTitle)
        .get();
    return result.docs.isEmpty;
  }

  static TextEditingController mealplanTitleTextFieldController =
      TextEditingController();
  bool validMealPlanName = true;

  static bool isPublicSwitchBtnAddNewMealplan = false;
//-------------------------------------------------------------------------------------------

  List<Step> stepList() => [
        Step(
          state: activeStepIndex <= 0 ? StepState.indexed : StepState.indexed,
          isActive: activeStepIndex >= 0,
          title: const Text('Title and status'),
          content: Container(
            child: Column(
              children: [
                TextField(
                  controller: mealplanTitleTextFieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter meal plan title',

                    //  onChanged: (value) {
                    //     recipeTitle = value;
                    //   }
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  child: Row(
                    children: [
                      Text("      Private"),
                      Switch(
                        value: isPublicSwitchBtnAddNewMealplan,
                        onChanged: (value) {
                          setState(() {
                            isPublicSwitchBtnAddNewMealplan = value;
                          });
                        },
                        activeTrackColor: Colors.orange[600],
                        activeColor: Color(0xFFeb6d44),
                      ),
                      Text("Public"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: StepState.indexed,

          isActive: activeStepIndex >= 1,
          title: const Text('Add recipes'),
          content: SizedBox(
            height: AppGlobals.screenHeight,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                HorizontalDayList(changeWeekday, true),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    // the white space
                    child: ListView.builder(
                      itemCount: mealInformation.length,
                      itemBuilder: (BuildContext context, int index) {
                        print('in add new plan _______________________');
                        print(mealInformation[index][0]);
                        print(mealInformation[index][1]);
                        print(mealInformation[index][2]);
                        return MealTile(
                          title: mealInformation[index][0],
                          mealPlanTypeOfMeal: mealInformation[index][1],
                          img: mealInformation[index][2],
                          isFromAddMealplan: true,
                        );
                      },
                    ), // we call the gird view to present them in the white space
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
          ),
          // ],
          // ),
          // ),
        )
      ];

  showAlertDialogCheckNumOfRecipes(BuildContext context) {
    // set up the button
    Widget yesButton = RaisedButton(
      color: Color(0xFFeb6d44),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Yes",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        // setState(() {
        Navigator.of(context).pop();

        appPages.showAlertDialogRcipeAdedSuccessfully(context, true);

        //to clear all the plan

        mealplanTitleTextFieldController.clear();
        MealPlansService.chosenMealDay = 'SUN';
        isPublicSwitchBtnAddNewMealplan = false;
        MealPlansService.hasMealPlanCollection = false;
        sunMealPlan.clear();
        monMealPlan.clear();
        tueMealPlan.clear();
        wedMealPlan.clear();
        thuMealPlan.clear();
        friMealPlan.clear();
        satMealPlan.clear();
        mealInformation.clear();

        sunMealPlan.addAll(initiateMealInformation);
        monMealPlan.addAll(initiateMealInformation);

        tueMealPlan.addAll(initiateMealInformation);

        wedMealPlan.addAll(initiateMealInformation);

        thuMealPlan.addAll(initiateMealInformation);

        friMealPlan.addAll(initiateMealInformation);

        satMealPlan.addAll(initiateMealInformation);

        //});
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
        "Warning",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "It seems that you do not enter some recipes \nAre you sure you want to continue to add the plan?",
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

  bool isBackAllowed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
            accentColor: Color(0xFFeb6d44),
            // primarySwatch: Color(0xFFeb6d44),
            colorScheme: ColorScheme.light(primary: Color(0xFFeb6d44))),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: activeStepIndex,
          steps: stepList(),
          onStepContinue: () {
            print('-----------------***************-----------');
            print(isBackAllowed);
            print(activeStepIndex);
            print('-----------------***************-----------');
            if (activeStepIndex < (stepList().length - 1)) {
              setState(() {
                print('onStepContinue');
                print(activeStepIndex);
                activeStepIndex += 1;
              });
            } else {
              print('Submited');
            }

            setState(() {
              isBackAllowed = true;
            });
          },
          onStepCancel: () {
            if (activeStepIndex == 0) {
              return;
            }
            print('^^^^^^^^^^^^^^');
            print(activeStepIndex);
            print('^^^^^^^^^^^^^^');
            setState(() {
              activeStepIndex -= 1;
            });
          },
          onStepTapped: (int index) {
            setState(() {
              activeStepIndex = index;
            });
          },
          controlsBuilder: (context, ControlsDetails controls) {
            final isLastStep = activeStepIndex == stepList().length - 1;
            return Container(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            (activeStepIndex > 0)
                                ? (Colors.grey)
                                : Color(0xFFeb6d44)),
                      ),
                      onPressed: () async {
                        print("--------------------------------------");
                        print("activeStepIndex");
                        print(activeStepIndex);
                        print("--------------------------------------");
                        if (isBackAllowed || activeStepIndex > 0) {
                          print("the condtion is met");
                          if (activeStepIndex == 0) {
                            return;
                          }
                          setState(() {
                            activeStepIndex -= 1;
                          });
                          controls.onStepCancel;
                        } else if (!isLastStep && activeStepIndex == 0) {
                          print('-----------------***************-----------');
                          print(isBackAllowed);
                          print(activeStepIndex);
                          print('-----------------***************-----------');
                          if (activeStepIndex < (stepList().length - 1)) {
                            setState(() {
                              print('onStepContinue');
                              print(activeStepIndex);
                              activeStepIndex += 1;
                            });
                          } else {
                            print('Submited');
                          }

                          controls.onStepContinue;
                          setState(() {
                            activeStepIndex = 1;
                          });
                        }
                      },
                      child: (activeStepIndex > 0)
                          ? const Text('Back')
                          : const Text('Next'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (isLastStep)
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFeb6d44)),
                        ),
                        onPressed: () async {
// else {
                          if (mealplanTitleTextFieldController.text.isEmpty ||
                              mealplanTitleTextFieldController.text == "") {
                            setState(() {
                              validTitleToSubmit = false;
                            });
                          } else {
                            validTitleToSubmit = true;
                          }

                          if (validTitleToSubmit) {
                            //    if (validMealPlanName) {

                            MealPlansService.addMealPlanTitleAndStatus(
                                mealplanTitleTextFieldController.text,
                                isPublicSwitchBtnAddNewMealplan);
                            ProfileState.isPinnedInPublicMealPlans =
                                isPublicSwitchBtnAddNewMealplan;

                            if (MealPlansService.countNumOfRecipes == 21) {
                              //check it
                              appPages.showAlertDialogRcipeAdedSuccessfully(
                                  context, true);

                              //to clear all the plan

                              mealplanTitleTextFieldController.clear();
                              MealPlansService.chosenMealDay = 'SUN';
                              isPublicSwitchBtnAddNewMealplan = false;
                              MealPlansService.hasMealPlanCollection = false;
                              sunMealPlan.clear();
                              monMealPlan.clear();
                              tueMealPlan.clear();
                              wedMealPlan.clear();
                              thuMealPlan.clear();
                              friMealPlan.clear();
                              satMealPlan.clear();
                              mealInformation.clear();

                              sunMealPlan.addAll(initiateMealInformation);
                              monMealPlan.addAll(initiateMealInformation);

                              tueMealPlan.addAll(initiateMealInformation);

                              wedMealPlan.addAll(initiateMealInformation);

                              thuMealPlan.addAll(initiateMealInformation);

                              friMealPlan.addAll(initiateMealInformation);

                              satMealPlan.addAll(initiateMealInformation);
                            } else {
                              showAlertDialogCheckNumOfRecipes(context);
                            }
                            MealPlansService.makePinnedMealplanAlwaysUp();
                            // to open the public or private mealplan list in profile page.

                            print(MealPlansService.countNumOfRecipes);
                            // appPages.showAlertDialogRcipeAdedSuccessfully(
                            //     context, true);

                            //     }
                            // else {
                            //   Flushbar(
                            //     backgroundColor: Theme.of(context).errorColor,
                            //     message: "The title is already exist",
                            //     duration: Duration(seconds: 4),
                            //   ).show(context);
                            // }
                          } else {
                            Flushbar(
                              backgroundColor: Theme.of(context).errorColor,
                              message: "Plases enter a title!",
                              duration: Duration(seconds: 4),
                            ).show(context);
                          }
                          //   }
                        },
                        child: const Text('Done'),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
