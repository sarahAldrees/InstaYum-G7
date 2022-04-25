import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/meal_plan/add_new_mealplan.dart';
import 'package:instayum/widget/profile/circular_loader.dart';

import 'recipe_item.dart';

// import '../bookmark/data.dart';

class MyRecipesScreen extends StatefulWidget {
  bool isFromMealPlan = false;
  String? userId;
  String? mealDay;
  String? mealPlanTypeOfMeal;
  MyRecipesScreen(
      {this.userId,
      required this.isFromMealPlan,
      this.mealDay,
      this.mealPlanTypeOfMeal});

  // my_recipes(this.autherName, this.autherImage, this.autherId);

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getRecipeObjects());
    //we call the method here to get the data immediately when init the page.
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Recipe> recpiesList = [];
  List<Recipe> userPublicRecpiesList = [];
  List<Recipe> userPrivateRecpiesList = [];
  List<String>? ingredientsList = [];
  List<String>? dirctionsList = [];
  List<String>? imageUrlsList = [];
  int? lengthOfIngredients = 0;
  int? lengthOfDirections = 0;
  int? lengthOfImages = 0;
  String? autherId;
  bool isLoading = true;

  void getRecipeObjects() {
    // User user = firebaseAuth.currentUser!;

    if (widget.userId != null) {
      FirebaseFirestore.instance
          .collection("recipes")
          .where("user_id", isEqualTo: widget.userId)
          .orderBy("timestamp", descending: true)
          .get()
          .then((snapshot) {
        recpiesList.clear();

        snapshot.docs.forEach(
          (doc) {
            Map data = doc.data();
            Recipe recipe = Recipe.fromJson(data as Map<String, dynamic>);
            String? recipeName = recipe.recipeTitle;
            String? typeOfMeal = recipe.typeOfMeal;
            String? category = recipe.category;
            String? cuisine = recipe.cuisine;
            String? img1 = recipe.img1;
            autherId = recipe.userId;
            bool public = recipe.isPublicRecipe ?? false;
            // recipe_image_url = data['recipe_image_url'],

            lengthOfIngredients = recipe.lengthOfIngredients;
            lengthOfDirections = recipe.lengthOfDirections;
            lengthOfImages = recipe.imageCount;

            for (int i = 0; i < lengthOfIngredients!; i++) {
              ingredientsList!.add(data['ing${i + 1}']);
            }
            for (int i = 0; i < lengthOfDirections!; i++) {
              dirctionsList!.add(data['dir${i + 1}']);
            }
            for (int i = 0; i < lengthOfImages!; i++) {
              imageUrlsList!.add(data['img${i + 1}']);
            }

            if (widget.userId != AppGlobals.userId) {
              // add only other user public recipes.
              if (public == true) {
                recpiesList.add(
                  Recipe(
                    recipeId: doc.id,
                    //imageURL: recipe_image_url,
                    recipeTitle: recipeName,
                    typeOfMeal: typeOfMeal,
                    category: category,
                    cuisine: cuisine,
                    img1: img1,
                    dirctions: dirctionsList,
                    ingredients: ingredientsList,
                    imageUrls: imageUrlsList,
                  ),
                );
              }
            } else {
              // add current user all recipes
              if (public == true) {
                userPublicRecpiesList.add(
                  Recipe(
                    recipeId: doc.id,
                    //imageURL: recipe_image_url,
                    recipeTitle: recipeName,
                    typeOfMeal: typeOfMeal,
                    category: category,
                    cuisine: cuisine,
                    img1: img1,
                    dirctions: dirctionsList,
                    ingredients: ingredientsList,
                    imageUrls: imageUrlsList,
                  ),
                );
              } else {
                userPrivateRecpiesList.add(
                  Recipe(
                    recipeId: doc.id,
                    //imageURL: recipe_image_url,
                    recipeTitle: recipeName,
                    typeOfMeal: typeOfMeal,
                    category: category,
                    cuisine: cuisine,
                    img1: img1,
                    dirctions: dirctionsList,
                    ingredients: ingredientsList,
                    imageUrls: imageUrlsList,
                  ),
                );
              }
            }
          },
        );
        isLoading = false;
        setState(() {});
      }).catchError((e) => print("error fetching data: $e"));
    }
  }

  bool isPublicRecipes = true;
  _switchbetweenPublicAndPrivateRecipes(bool val) {
    if (isPublicRecipes != val) {
      setState(() {
        isPublicRecipes = val;
      });
    }
  }

  Widget getUserPublicOrPrivateRecipes() {
    return Expanded(
      child: GridView.count(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2, // 2 items in each row
          crossAxisSpacing: 20,
          padding: EdgeInsets.all(20),
          mainAxisSpacing: 10,
          // map all available cookbooks and list them in Gridviwe.
          children: isPublicRecipes
              ? userPublicRecpiesList
                  .map(
                    (e) => RecipeItem(
                        "",
                        //  e.key,
                        // widget.autherName,
                        // widget.autherImage,
                        e.userId,
                        e.recipeId,
                        e.recipeTitle,
                        e.img1,
                        e.typeOfMeal,
                        e.category,
                        e.cuisine,
                        e.ingredients,
                        e.dirctions,
                        e.imageUrls,
                        widget.isFromMealPlan,
                        widget.mealDay!,
                        widget.mealPlanTypeOfMeal!
                        // e.ingredients,
                        // e.dirctions,
                        // e.imageUrls,
                        ),
                  )
                  .toList()
              : userPrivateRecpiesList
                  .map(
                    (e) => RecipeItem(
                        "",
                        //  e.key,
                        // widget.autherName,
                        // widget.autherImage,
                        e.userId,
                        e.recipeId,
                        e.recipeTitle,
                        e.img1,
                        e.typeOfMeal,
                        e.category,
                        e.cuisine,
                        e.ingredients,
                        e.dirctions,
                        e.imageUrls,
                        widget.isFromMealPlan,
                        widget.mealDay!,
                        widget.mealPlanTypeOfMeal!
                        // e.ingredients,
                        // e.dirctions,
                        // e.imageUrls,
                        ),
                  )
                  .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => getRecipeObjects());
    return isLoading
        ? CustomCircularLoader()
        : Column(children: [
            SizedBox(
              height: 5,
              width: 100,
            ),
            (widget.userId != AppGlobals.userId)
                ? recpiesList.isEmpty
                    ? Center(
                        heightFactor: 10, child: Text("No recipes available!"))
                    : Expanded(
                        flex: 500,
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 2, // 2 items in each row
                            crossAxisSpacing: 20,
                            // padding: EdgeInsets.all(20),
                            mainAxisSpacing: 10,
                            // map all available cookbooks and list them in Gridviwe.
                            children: recpiesList
                                .map((e) => RecipeItem(
                                    "",
                                    //  e.key,
                                    // widget.autherName,
                                    // widget.autherImage,
                                    e.userId,
                                    e.recipeId,
                                    e.recipeTitle,
                                    e.img1,
                                    e.typeOfMeal,
                                    e.category,
                                    e.cuisine,
                                    e.ingredients,
                                    e.dirctions,
                                    e.imageUrls,
                                    widget.isFromMealPlan,
                                    widget.mealDay!,
                                    widget.mealPlanTypeOfMeal!
                                    // e.ingredients,
                                    // e.dirctions,
                                    // e.imageUrls,
                                    ))
                                .toList()),
                      )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _switchbetweenPublicAndPrivateRecipes(true);
                        },
                        child: Container(
                          // margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                          height: 40,
                          width: AppGlobals.screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: isPublicRecipes
                                ? Colors.grey[200]
                                : Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.lock_open,
                                color: isPublicRecipes
                                    ? AppColors.primaryColor
                                    : Colors.grey[600],
                              ),
                              onPressed: () {
                                _switchbetweenPublicAndPrivateRecipes(true);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      (AddNewMealPlanState.isPublicSwitchBtnAddNewMealplan &&
                              widget.isFromMealPlan)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                _switchbetweenPublicAndPrivateRecipes(false);
                              },
                              child: Container(
                                // margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                height: 40,
                                width: AppGlobals.screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: !isPublicRecipes
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
                                      color: !isPublicRecipes
                                          ? AppColors.primaryColor
                                          : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      _switchbetweenPublicAndPrivateRecipes(
                                          false);
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
            (isPublicRecipes &&
                    userPublicRecpiesList.isEmpty &&
                    widget.userId == AppGlobals.userId)
                ? Center(
                    heightFactor: 10,
                    child: Text("No public recipes available!"),
                  )
                : (!isPublicRecipes &&
                        userPrivateRecpiesList.isEmpty &&
                        widget.userId == AppGlobals.userId)
                    ? Center(
                        heightFactor: 10,
                        child: Text("No private recipes available!"))
                    : getUserPublicOrPrivateRecipes(),
          ]);
  }
}
