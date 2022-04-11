import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';
import 'package:instayum/widget/bookmark/cookbook_recipes.dart';
import 'package:instayum/widget/discover/search/search_page.dart';
import 'package:instayum/widget/meal_plan/mealplan_service.dart';

import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/followers_numbers.dart';
import '../recipe_view/my_recipes_screen.dart';
import '../bookmark/bookmarks_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseMealRecipes extends StatefulWidget {
  String mealDay;
  String mealPlanTypeOfMeal;
  ChooseMealRecipes(this.mealDay, this.mealPlanTypeOfMeal);
  @override
  State<StatefulWidget> createState() => ChooseMealRecipesState();
}

class ChooseMealRecipesState extends State<ChooseMealRecipes> {
  // ---------------- Database -------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? userUsername = AppGlobals.userName;
  String? imageURL = AppGlobals.userImage;
  String? uId = AppGlobals.userId;
  bool isLoading = false;

//getData() to get the data of users like username, image_url from database

  @override
  void initState() {
    super.initState();
    //we call the method here to get the data immediately when init the page.
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

//----------------------------------------------------------
// build a circular user image

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery
  @override
  Widget build(BuildContext context) {
    if (MealPlansService.hasMealPlanCollection) {
    } else {
      MealPlansService.hasMealPlanCollection = true;
      MealPlansService.addMealPlanDatabase();
    }
    return Scaffold(
      appBar: new AppBar(
        title: Text('Choose recipe'),
        backgroundColor: Color(0xFFeb6d44),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? CustomCircularLoader()
          : DefaultTabController(
              length: 3,

              // allows you to build a list of elements that would be scrolled away till the body reached the top

              // You tab view goes here and its bar view
              child: Column(
                children: <Widget>[
                  //------------------------------------------
                  TabBar(
                    labelStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    labelColor: Color(0xFFeb6d44),
                    indicatorColor: Color(0xFFeb6d44),
                    tabs: [
                      Tab(
                          icon: Icon(Icons.assignment_outlined),
                          text: ("My recipes")),
                      Tab(icon: Icon(Icons.bookmark), text: ("Bookmarks")),
                      Tab(icon: Icon(Icons.search), text: ("Search")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        //This list is the content of each tab.
                        // ------------ list item 1 tab view bookmarks screen.
                        uId != null
                            ? MyRecipesScreen(
                                userId: uId,
                                isFromMealPlan: true,
                                mealDay: widget.mealDay,
                                mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                              )
                            : CustomCircularLoader(),

                        // ------------ list item 2 tab view bookmarks screen.

                        // ------------ list item 3 tab view bookmarks screen.

                        BookmarkedRecipes(
                          isFromMealPlan: true,
                          mealDay: widget.mealDay,
                          mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                        ),
                        SearchPage(
                          isFromMealPlan: true,
                          mealDay: widget.mealDay,
                          mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
