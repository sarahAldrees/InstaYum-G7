import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
//import 'package:instayum/model/mealplan.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/profile.dart';

class MyMealplanScreen extends StatefulWidget {
  String? typeOfMeal;
  String? day = 'SUN';
  String? userID = '';
  bool isFromUserProfileView = false;
  MyMealplanScreen(
      {this.typeOfMeal,
      this.day,
      required this.isFromUserProfileView,
      this.userID});

  @override
  State<StatefulWidget> createState() => MyMealplanScreenState();
}

class MyMealplanScreenState extends State<MyMealplanScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMealplans());

    //we call the method here to get the data immediately when init the page.
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<String> weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
  List<String> typeOfMeals = ["Breakfast", "Lunch", "Dinner"];
  //List<MealPlan> mealplansList = [];
  String mealplanId = "";
  // List<MealPlan> userPublicMealplanList = [];
  //List<MealPlan> userPrivateMealplanList = [];

  bool isLoading = true;
  bool isPublicMealplanListEmpty = true;
  bool isPrivateMealplanListEmpty = true;

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

  //-------------------------------------------------------------------------
  //the 1 first part of sepreate operation
  Future<void> getMealplans() async {
    String? userID =
        widget.isFromUserProfileView ? widget.userID : AppGlobals.userId;
    String mealPlanID = "";
    String mealPlanTitle = "";
    bool isPublicMealplans = true;
    bool isPinned = false;
    await firebaseFirestore
        .collection("users")
        .doc(userID)
        .collection("mealPlans")
        .orderBy("timestamp", descending: true)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) async {
        mealPlanID = doc.id;
        mealPlanTitle = doc.data()['mealplan_title'];
        isPublicMealplans = doc.data()['is_public_mealplan'];
        isPinned = doc.data()['is_pinned'];

        // if (isPinned) {
        //   DateTime timestamp = DateTime.now();

        //   await firebaseFirestore
        //       .collection("users")
        //       .doc(userID)
        //       .collection("mealPlans")
        //       .doc(doc.id)
        //       .update({"timestamp": timestamp});
        // }

        if (isPublicMealplans) {
          print("tttttttttttttttttttttttttttttttttt");
          print("I am in public mealplan list");

          setState(() {});
        } else {
          print("tttttttttttttttttttttttttttttttttt");

          print("I am in private mealplan list");
        }
        // mealplansList.add(MealPlan(
        //     mealplanID: mealPlanID,
        //     mealplanTitle: mealPlanTitle,
        //     sunMealPlan: sunMealPlan,
        //     monMealPlan: monMealPlan,
        //     tueMealPlan: tueMealPlan,
        //     wedMealPlan: wedMealPlan,
        //     thuMealPlan: thuMealPlan,
        //     friMealPlan: friMealPlan,
        //     satMealPlan: satMealPlan));
        // setState(() {});
      });
    });
    // }//);
    //if (userPublicMealplanList.isEmpty) {
    isPublicMealplanListEmpty = true;
    setState(() {
      isLoading = false;
    });
    // }
    //else {
    //   isPublicMealplanListEmpty = false;
    // }

    isLoading = false;
  }

  bool isPublicMealplans = true;

  _switchbetweenPublicAndPrivateMealplans(bool val) {
    if (isPublicMealplans != val) {
      setState(() {
        isPublicMealplans = val;
        isPublicMealplans = val;
      });
    }
  }

  List<String> getOneDayMeals(String recipeID, String typeOfMeal) {
    List<String> oneDayMeals = [];
    FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeID)
        .get()
        .then((recipeData) {
      oneDayMeals = [
        recipeData.data()!["recipe_title"],
        typeOfMeal,
        recipeData.data()!["img1"]
      ];
    });
    return oneDayMeals;
  }

  Widget mealplansOREmptyMessage(
      {isPublicMealplans,
      isPublicMealplanListEmpty,
      isPrivateMealplanListEmpty}) {
    return Column(
      children: [
        // SizedBox(
        //   height: 5,
        //   width: 100,
        // ),
        widget.isFromUserProfileView
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _switchbetweenPublicAndPrivateMealplans(true);
                    },
                    child: Container(
                      // margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                      height: 40,
                      width: AppGlobals.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color:
                            isPublicMealplans ? Colors.grey[200] : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.lock_open,
                            color: isPublicMealplans
                                ? AppColors.primaryColor
                                : Colors.grey[600],
                          ),
                          onPressed: () {
                            _switchbetweenPublicAndPrivateMealplans(true);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      _switchbetweenPublicAndPrivateMealplans(false);
                    },
                    child: Container(
                      height: 40,
                      width: AppGlobals.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: !isPublicMealplans
                            ? Colors.grey[200]
                            : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.lock,
                            color: !isPublicMealplans
                                ? AppColors.primaryColor
                                : Colors.grey[600],
                          ),
                          onPressed: () {
                            _switchbetweenPublicAndPrivateMealplans(false);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        (isPublicMealplans && isPublicMealplanListEmpty)
            ? Center(
                heightFactor: 20,
                child: Text("No public mealplans available!"),
              )
            : (!isPublicMealplans && isPrivateMealplanListEmpty)
                ? Center(
                    heightFactor: 20,
                    child: Text("No private mealplans available!"))
                : Container()
      ],
    );
  }

  bool validMealPlanName = true;
  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? CustomCircularLoader()
        : mealplansOREmptyMessage(
            isPublicMealplans: isPublicMealplans,
            isPublicMealplanListEmpty: isPublicMealplanListEmpty,
            isPrivateMealplanListEmpty: isPrivateMealplanListEmpty);
  }
}
