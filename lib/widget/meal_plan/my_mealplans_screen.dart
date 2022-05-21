import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/mealplan.dart';
import 'package:instayum/widget/meal_plan/mealplan_card.dart';
import 'package:instayum/widget/meal_plan/mealplan_service.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/profile.dart';

class MyMealplanScreen extends StatefulWidget {
  String? typeOfMeal;
  String? day = 'SUN';
  String? userID = '';
  bool isFromUserProfileView = false;
  String? anotherUsername;
  MyMealplanScreen(
      {this.typeOfMeal,
      this.day,
      required this.isFromUserProfileView,
      this.userID,
      this.anotherUsername});

  @override
  State<StatefulWidget> createState() => MyMealplanScreenState();
}

class MyMealplanScreenState extends State<MyMealplanScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMealplans());
    MealPlansService.deleteEmptyMealPlans();

    //we call the method here to get the data immediately when init the page.
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<String> weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
  List<String> typeOfMeals = ["Breakfast", "Lunch", "Dinner"];
  List<MealPlan> mealplansList = [];
  String mealplanId = "";
  List<MealPlan> userPublicMealplanList = [];
  List<MealPlan> userPrivateMealplanList = [];

  bool isLoading = true;
  bool isPublicMealplanListEmpty = true;
  bool isPrivateMealplanListEmpty = true;

  List<List<String>> initializationData = [
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
  //the  first part of sepreate operation
  Future<void> getMealplans() async {
    String? userID =
        widget.isFromUserProfileView ? widget.userID : AppGlobals.userId;
    String mealPlanID = "";
    String mealPlanTitle = "";
    String username = "";
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
        username = doc.data()['username'];

        if (isPublicMealplans) {
          userPublicMealplanList.add(MealPlan(
              mealplanID: mealPlanID,
              mealplanTitle: mealPlanTitle,
              isPinned: isPinned,
              username: username,
              sunMealPlan: sunMealPlan,
              monMealPlan: monMealPlan,
              tueMealPlan: tueMealPlan,
              wedMealPlan: wedMealPlan,
              thuMealPlan: thuMealPlan,
              friMealPlan: friMealPlan,
              satMealPlan: satMealPlan));
          setState(() {});
        } else {
          userPrivateMealplanList.add(MealPlan(
              mealplanID: mealPlanID,
              mealplanTitle: mealPlanTitle,
              isPinned: isPinned,
              username: username,
              sunMealPlan: sunMealPlan,
              monMealPlan: monMealPlan,
              tueMealPlan: tueMealPlan,
              wedMealPlan: wedMealPlan,
              thuMealPlan: thuMealPlan,
              friMealPlan: friMealPlan,
              satMealPlan: satMealPlan));
          if (mounted) setState(() {});
        }
      });
    });

    if (userPublicMealplanList.isEmpty) {
      isPublicMealplanListEmpty = true;
      if (mounted)
        setState(() {
          isLoading = false;
        });
    } else {
      isPublicMealplanListEmpty = false;
    }
    if (userPrivateMealplanList.isEmpty) {
      isPrivateMealplanListEmpty = true;
      setState(() {
        isLoading = false;
      });
    } else {
      isPrivateMealplanListEmpty = false;
    }
    isLoading = false;
  }

  bool isPublicMealplans = ProfileState
      .isPinnedInPublicMealPlans; // to not make it always true and keep the last chiose of user eihter public or private
  _switchbetweenPublicAndPrivateMealplans(bool val) {
    if (isPublicMealplans != val) {
      setState(() {
        isPublicMealplans = val;
        ProfileState.isPinnedInPublicMealPlans = val;
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

  Widget getUserPublicOrPrivateMealplans() {
    return Expanded(
        child: (isPublicMealplans || widget.isFromUserProfileView)
            ? ListView.builder(
                itemCount: userPublicMealplanList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MealPlanCard(
                    mealplanTitle: userPublicMealplanList[index].mealplanTitle,
                    anotherUserID: widget.userID,
                    currentUsername: userPublicMealplanList[index].username,
                    anotherUsername: widget.anotherUsername,
                    isFromUserProfileView: widget.isFromUserProfileView,
                    mealplanID: userPublicMealplanList[index].mealplanID,
                    isPinned: userPublicMealplanList[index].isPinned!,
                    sunMealPlan: userPublicMealplanList[index].sunMealPlan,
                    monMealPlan: userPublicMealplanList[index].monMealPlan,
                    tueMealPlan: userPublicMealplanList[index].tueMealPlan,
                    wedMealPlan: userPublicMealplanList[index].wedMealPlan,
                    thuMealPlan: userPublicMealplanList[index].thuMealPlan,
                    friMealPlan: userPublicMealplanList[index].friMealPlan,
                    satMealPlan: userPublicMealplanList[index].satMealPlan,
                  );
                })
            : ListView.builder(
                itemCount: userPrivateMealplanList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MealPlanCard(
                    mealplanTitle: userPrivateMealplanList[index].mealplanTitle,
                    mealplanID: userPrivateMealplanList[index].mealplanID,
                    isFromUserProfileView: widget.isFromUserProfileView,
                    isPinned: userPrivateMealplanList[index].isPinned!,
                    // username: userPrivateMealplanList[index].username,
                    currentUsername: userPrivateMealplanList[index].username,
                    anotherUsername: widget.anotherUsername,
                    sunMealPlan: userPrivateMealplanList[index].sunMealPlan,
                    monMealPlan: userPrivateMealplanList[index].monMealPlan,
                    tueMealPlan: userPrivateMealplanList[index].tueMealPlan,
                    wedMealPlan: userPrivateMealplanList[index].wedMealPlan,
                    thuMealPlan: userPrivateMealplanList[index].thuMealPlan,
                    friMealPlan: userPrivateMealplanList[index].friMealPlan,
                    satMealPlan: userPrivateMealplanList[index].satMealPlan,
                  );
                }));
  }

  Widget mealplansOREmptyMessage(
      {isPublicMealplans,
      isPublicMealplanListEmpty,
      isPrivateMealplanListEmpty}) {
    return Column(
      children: [
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
        (isPublicMealplans &&
                isPublicMealplanListEmpty &&
                !widget.isFromUserProfileView)
            ? Center(
                heightFactor: 10,
                child: Text("No public mealplans available!"),
              )
            : (!isPublicMealplans &&
                    isPrivateMealplanListEmpty &&
                    !widget.isFromUserProfileView)
                ? Center(
                    heightFactor: 10,
                    child: Text("No private mealplans available!"))
                : (widget.isFromUserProfileView && isPublicMealplanListEmpty)
                    ? Center(
                        heightFactor: 10,
                        child: Text("No mealplans available!"),
                      )
                    : getUserPublicOrPrivateMealplans(),
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
