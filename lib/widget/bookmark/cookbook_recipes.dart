import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/recipe_view/recipe_item.dart';

class CookbookRecipes extends StatefulWidget {
  @override
  String? cookbookID;
  bool flag = true;
  static bool isNeedUpdate = true;
  bool isFromMealPlan;
  String? mealDay;
  String? mealPlanTypeOfMeal;

  CookbookRecipes(
      {this.cookbookID,
      required this.isFromMealPlan,
      this.mealDay,
      this.mealPlanTypeOfMeal});

  State<CookbookRecipes> createState() => CookbookRecipesState();
}

class CookbookRecipesState extends State<CookbookRecipes> {
  List<Recipe> recpiesList = [];

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  List<String> imageUrlsList = [];

  int? lengthOfIngredients = 0;

  int? lengthOfDirections = 0;

  int? lengthOfImages = 0;

  int? numberOfRecipes = 0;

  String? autherId;
  String? recipeId;
  _getBookmarkedRecipes() {
    // while (CookbookRecipes.isNeedUpdate) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .snapshots()
        .listen((document) {
      recpiesList.clear();
      Map<String, dynamic>? data = document.data();
      Cookbook bookmarkedRecipe = Cookbook.fromJson(data!);

      for (int i = 0; i < bookmarkedRecipe.bookmarkedList!.length; i++) {
//----------------------------------------------------------------
        FirebaseFirestore.instance
            .collection("recipes")
            .doc(bookmarkedRecipe.bookmarkedList![i])
            .get()
            .then((doc) {
          ingredientsList = [];
          dirctionsList = [];
          imageUrlsList = [];
          lengthOfIngredients = doc.data()?['length_of_ingredients'];
          lengthOfDirections = doc.data()?['length_of_directions'];
          lengthOfImages = doc.data()?['image_count'];

          for (int i = 0; i < lengthOfIngredients!; i++) {
            {
              ingredientsList.add(
                doc.data()?['ing${i + 1}'],
              );
            }
          }
          for (int i = 0; i < lengthOfDirections!; i++) {
            dirctionsList.add(
              doc.data()?['dir${i + 1}'],
            );
          }
          for (int i = 0; i < lengthOfImages!; i++) {
            imageUrlsList.add(
              doc.data()?['img${i + 1}'],
            );
          }

          recpiesList.add(Recipe(
            userId: autherId,
            recipeId: doc.id,
            recipeTitle: doc.data()!['recipe_title'],
            typeOfMeal: doc.data()!['type_of_meal'],
            category: doc.data()!['category'],
            cuisine: doc.data()!['cuisine'],
            img1: doc.data()!["img1"],
            dirctions: dirctionsList,
            ingredients: ingredientsList,
            imageUrls: imageUrlsList,
          ));
          if (mounted)
            setState(() {
              recpiesList = recpiesList;
            });
        });
      }
      if (mounted) setState(() {});
    });
  }

  void initState() {
    super.initState();
    setState(() {
      if (!recpiesList.isEmpty) {
        recpiesList.clear();
      }
    });
    _getBookmarkedRecipes();

    //we call the method here to get the data immediately when init the page.
  }

  //----------------------------------DELETE COOKBOOK-----------------------------
  showAlertDialogDeleteCookbook(BuildContext context) {
    // set up the button
    Widget yesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () {
        deleteCookbook();
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
        "Delete cookbook",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        " Are you sure you want to delete this cookbook?  ",
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

  void deleteCookbook() {
    print("inside delete method");
    FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .delete();
    Navigator.of(context).pop();
    setState(() {
      print("After navigitor");
    });
  }

  @override
  Widget build(BuildContext context) {
    print(autherId);
    if (widget.isFromMealPlan) {
      return Scaffold(
        appBar: new AppBar(
          title: Text(widget.cookbookID! + " cookbook"),
          backgroundColor: Color(0xFFeb6d44),
        ),
        body: GridView.count(
            crossAxisCount: 2, // 2 items in each row
            crossAxisSpacing: 20,
            padding: EdgeInsets.all(20),
            mainAxisSpacing: 10,
            children: [
              ...recpiesList
                  .map(
                    (e) => RecipeItem(
                        widget.cookbookID,
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
                        widget.mealPlanTypeOfMeal!),
                  )
                  .toList(),
            ]),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          title: Text(widget.cookbookID! + " cookbook"),
          backgroundColor: Color(0xFFeb6d44),
          actions: [
            if (widget.cookbookID != 'All bookmarked recipes')
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        //  Icons.ios_share,
                        size: 30,
                      ),
                      onPressed: () {
                        showAlertDialogDeleteCookbook(context);
                      }),
                ],
              ),
          ],
        ),
        body: GridView.count(
            crossAxisCount: 2, // 2 items in each row
            crossAxisSpacing: 20,
            padding: EdgeInsets.all(20),
            mainAxisSpacing: 10,
            children: [
              ...recpiesList
                  .map((e) => RecipeItem(
                      widget.cookbookID,
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
                      widget.mealPlanTypeOfMeal!))
                  .toList(),
            ]),
      );
    }
    // } else {
    //widget.flag = true;
    // return Scaffold(
    //     body: Center(
    //         child: CircularProgressIndicator(
    //   color: Colors.orange,
    // )));
    // }
  }
}
