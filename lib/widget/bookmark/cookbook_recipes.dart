import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/cookbook.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/recipe_view/recipe_item.dart';

import 'bookmarks_recipes_screen.dart';

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

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  List<String> imageUrlsList = [];

  int lengthOfIngredients = 0;

  int lengthOfDirections = 0;

  int lengthOfImages = 0;

  int numberOfRecipes = 0;

  String autherId;
  String recipeId;
  _getBookmarkedRecipes() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .collection("bookmarked_recipe")
        .snapshots()
        .listen((data) {
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
            .snapshots()
            .listen((doc) {
          ingredientsList = [];
          dirctionsList = [];
          imageUrlsList = [];
          lengthOfIngredients = doc.data()['length_of_ingredients'];
          lengthOfDirections = doc.data()['length_of_directions'];
          lengthOfImages = doc.data()['image_count'];

          for (int i = 0; i < lengthOfIngredients; i++) {
            {
              ingredientsList.add(
                doc.data()['ing${i + 1}'],
              );
            }
          }
          for (int i = 0; i < lengthOfDirections; i++) {
            dirctionsList.add(
              doc.data()['dir${i + 1}'],
            );
          }
          for (int i = 0; i < lengthOfImages; i++) {
            imageUrlsList.add(
              doc.data()['img${i + 1}'],
            );
          }
          // recipe_image_url = doc.data()['recipe_image_url'],

          //setState(() {
          recpiesList.add(Recipe(
            autherId: autherId,
            id: doc.id,
            recipeName: doc.data()['recipe_title'],
            typeOfMeal: doc.data()['type_of_meal'],
            category: doc.data()['category'],
            cuisine: doc.data()['cuisine'],
            mainImageURL: doc.data()["img1"],
            dirctions: dirctionsList,
            ingredients: ingredientsList,
            imageUrls: imageUrlsList,
          ));
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

  void getCookbookObjects() async {
    print("inside getCookbookObjects()");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;
    final timestamp =
        DateTime.now(); // to update the time and make the default upper
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("cookbooks")
        .doc("All bookmarked recipes")
        .update({"timestamp": timestamp});

    BookmarkedRecipesState.Cookbooks_List = [];
    User user = currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("cookbooks")
        .orderBy("timestamp", descending: true)
        //  .doc(cookBookTitle)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
        (doc) => {
          BookmarkedRecipesState.Cookbooks_List.add(
            Cookbook(
              id: doc.data()['cookbook_id'],
              // cookbookName: ,
              imageURLCookbook: doc.data()['cookbook_img_url'],
            ),
          ),
        },
      );
      if (this.mounted) {
        print("Set state in getCookbookObjects workd222222");
        setState(() {});
      }
    });
    // setState(() {
    //   print("second set state worked");
    // });
  }

  void deleteCookbook() {
    print("inside delete method");
    // int index;
    // for (int i = 0; i < BookmarkedRecipesState.Cookbooks_List.length; i++) {
    //   if (BookmarkedRecipesState.Cookbooks_List[i].id == widget.cookbookID) {
    //     print("Founded");
    //     index = i;
    //   }
    // }
    // BookmarkedRecipesState.Cookbooks_List.removeAt(index);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("cookbooks")
        .doc(widget.cookbookID)
        .delete();

    // setState(() {});
    setState(() {
      getCookbookObjects();
    });
    // setState(() {
    //   BookmarkedRecipesState.updateCookbookScreen();
    // });
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
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      //  Icons.ios_share,
                      size: 30,
                    ),
                    onPressed: () {
                      print("clicked on delete");
                      deleteCookbook();
                      getCookbookObjects();
                      setState(() {
                        print("DEEEEEEEELEEEEEEETEEEEED");
                      });
                      // setState(() {});
                      //setstat :change the kind of ici=on and add it to bookmark list
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
                      e.autherId,
                      e.id,
                      e.recipeName,
                      e.mainImageURL,
                      e.typeOfMeal,
                      e.category,
                      e.cuisine,
                      e.ingredients,
                      e.dirctions,
                      e.imageUrls))
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
