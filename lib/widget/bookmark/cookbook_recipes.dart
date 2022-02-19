import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/recipe_view/recipe_item.dart';

class CookbookRecipes extends StatefulWidget {
  @override
  String cookbookID;
  bool flag = true;
  static bool isNeedUpdate = true;

  CookbookRecipes(this.cookbookID);

  State<CookbookRecipes> createState() => CookbookRecipesState();
}

class CookbookRecipesState extends State<CookbookRecipes> {
  List<Recipe> recpiesList = [];

  List<String>? ingredientsList = [];

  List<String>? dirctionsList = [];

  List<String>? imageUrlsList = [];

  int? lengthOfIngredients = 0;

  int? lengthOfDirections = 0;

  int? lengthOfImages = 0;

  int? numberOfRecipes = 0;

  String? autherId;
  String? recipeId;
  _getBookmarkedRecipes() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .collection("bookmarked_recipe")
        .get()
        .then((data) {
      recpiesList.clear();
      data.docs.forEach((doc) async {
        recpiesList.clear();
        autherId = doc.data()['autherId'];
        recipeId = doc.data()['recipeId'];
        //setState(() {});
        // if (recpiesList.isEmpty) {
        //   recpiesList = [];
        // }

//----------------------------------------------------------------
        await FirebaseFirestore.instance
            .collection("users")
            .doc(autherId)
            .collection("recipes")
            .doc(recipeId)
            .get()
            .then((doc) {
          Recipe recipe = Recipe.fromJson(doc as Map<String, dynamic>);
          String? recipeName = recipe.recipeTitle;
          String? typeOfMeal = recipe.typeOfMeal;
          String? category = recipe.category;
          String? cuisine = recipe.cuisine;
          String? img1 = recipe.img1;
          autherId = recipe.userId;
          bool public = recipe.isPublicRecipe ?? false;
          lengthOfIngredients = recipe.lengthOfIngredients!;
          lengthOfDirections = recipe.lengthOfDirections;
          lengthOfImages = recipe.imageCount!;
          for (int i = 0; i < lengthOfIngredients!; i++) {
            ingredientsList!.add(doc['ing${i + 1}']);
          }
          for (int i = 0; i < lengthOfDirections!; i++) {
            dirctionsList!.add(doc['dir${i + 1}']);
          }
          for (int i = 0; i < lengthOfImages!; i++) {
            imageUrlsList!.add(doc['img${i + 1}']);
          }
          recpiesList.add(
            Recipe(
              recipeId: doc.id,
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

          //});
          if (mounted)
            setState(() {
              recpiesList = recpiesList;
            });
        });
      });

      if ((widget.flag || CookbookRecipes.isNeedUpdate) && mounted) {
        widget.flag = false;
        CookbookRecipes.isNeedUpdate = false;
        setState(() {});
      }
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
        .doc(FirebaseAuth.instance.currentUser!.uid)
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
    setState(() {
      recpiesList;
    });
    // print(recpiesList[0].autherId);

    print(autherId);
    if (!widget.flag) {
      return Scaffold(
        appBar: new AppBar(
          title: Text(widget.cookbookID + " cookbook"),
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
                        // widget.autherName,
                        // widget.autherImage,
                        widget.cookbookID,
                        autherId,
                        e.recipeId,
                        e.recipeTitle,
                        e.img1,
                        e.typeOfMeal,
                        e.category,
                        e.cuisine,
                        e.ingredients,
                        e.dirctions,
                        e.imageUrls,
                      ))
                  .toList(),
            ]),
      );
    } else {
      widget.flag = true;
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
        color: Colors.orange,
      )));
    }
  }
}
