import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/bookmark/bookmarks_recipes_screen.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/profile/profile.dart';
import 'package:instayum/widget/recipe_view/comment.dart';
import 'package:instayum/widget/recipe_view/convert_to_check_box.dart';
import 'package:instayum/widget/recipe_view/rating_recipe.dart';
import 'package:instayum/widget/recipe_view/user_information_design.dart';
import 'package:instayum/widget/recipe_view/view_reicpe_flotingbutton.dart';

import '../../constant/app_colors.dart';
import '../meal_plan/add_new_mealplan.dart';
import '../meal_plan/mealplan_service.dart';

class RecipeView extends StatefulWidget {
  String? cookbook;
  String? autherId;
  String? recipeid;
  bool isFromMealPlan = false;
  String? mealDay;
  String? mealPlanTypeOfMeal;

  // String _recipeName;
  // String _mainImageUrl;
  // String _typeOfMeal;
  // String _category;
  // String _cuisine;
  // List<String> _ingredients;
  // List<String> _dirctions;
  // List<String> _imageUrls;

  RecipeView({
    Key? key,
    this.cookbook,
    this.autherId,
    required this.recipeid,
    required this.isFromMealPlan,
    this.mealDay,
    this.mealPlanTypeOfMeal,
    // this._recipeName,
    // this._mainImageUrl,
    // this._typeOfMeal,
    // this._category,
    // this._cuisine,
    // this._ingredients,
    // this._dirctions,
    // this._imageUrls,
  }) : super(key: key);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String? recipeName;
  String? mainImageUrl;
  String? typeOfMeal;
  String? category;
  String? cuisine;

  int? lengthOfIngredients = 0;
  int? lengthOfDirections = 0;
  int? lengthOfImages = 0;
  List<String?> ingredients = [];
  List<String?> dirctions = [];
  List<String?> imageUrls = [];
  bool isLoading = true;
  int bookmarkCounter = 0;
  int mealPlanCounter = 0;
  //-------------------------------------------------
  bool recipeExist = false;
  bool ishappend = false;
  List<String?> _bookmarkedList = [];
  Widget bookmarkIcon() {
    if (!ishappend) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cookbooks")
          .doc("All bookmarked recipes")
          .get()
          .then((document) {
        if (document != null) {
          // print('rating data: ${document.data()}');
          //usersAlredyRate.clear();
          Map<String, dynamic>? data = document.data();

          if (data != null) {
            print("--------------------------------------4444---------");

            Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
            print(bookmarkedRecipe.id);

            _bookmarkedList = List.from(bookmarkedRecipe.bookmarkedList!);
            if (!_bookmarkedList.isEmpty) print(_bookmarkedList[0]);
            setState(() {
              _bookmarkedList;
              ishappend = true;
            });
          }
        }
      });
    }
    if (_bookmarkedList.contains(widget.recipeid)) {
      setState(() {
        recipeExist = true;
      });
    }
    print("--------------------ghada------------------------------------");
    print(recipeExist);
    if (recipeExist) {
      return IconButton(
          icon: Icon(
            Icons.bookmark,
            size: 26,
          ),
          onPressed: () {
            //------------------delete from bookmark recipe--------------
            unBookmarkRecipe();

            //-----------------------------------------------------------
          });
    } else {
      setState(() {
        BookmarkedRecipes.Saved = false;
      });
      return IconButton(
          icon: Icon(
            Icons.bookmark_add_outlined,
            size: 26,
          ),
          onPressed: () {
            // setState(() {
            CookbookItem.isBrowse = false;
            BookmarkedRecipes.Saved = true;
            //});

            ///------------------bookmark --------
            showModalBottomSheet(
                isDismissible: false,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                context: context,
                builder: (context) {
                  return BookmarkedRecipes(
                    recipeId: widget.recipeid!,
                    isFromMealPlan: false,
                    mealDay: "",
                    mealPlanTypeOfMeal: "",
                  );
                  // return bookmarked_recipes();
                });

            FirebaseFirestore.instance
                .collection("recipes")
                .doc(widget.recipeid)
                .update({
              "bookmarkCounter": bookmarkCounter + 1,
            });
            setState(() {
              ++bookmarkCounter;
              recipeExist = true;
            });

            //setstat :change the kind of ici=on and add it to bookmark list
          });
    }
  }

//---------------------------------------- try 1 unbookmark -----------------------------------------------
  void unBookmarkRecipe() {
    // // List b2 = [];

    // if (widget.cookbook == "All bookmarked recipes" || widget.cookbook == "") {
    //  // deletFromAllCookbooks();

    // } else {
    //   deletFromThisCookbook();
    // }
    recipeExist = false;
    if (widget.cookbook == "All bookmarked recipes" || widget.cookbook == "") {
      //delet from all(okay ,cancel)

      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              title: Column(
                children: [
                  Text(
                    'Are you sure to remove the recipe from all cookbooks?',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actions: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, right: 30, left: 30, bottom: 0),
                        child: Column(
                          children: [
                            ElevatedButton(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Center(
                                            child: Icon(
                                                Icons.delete_outline_rounded)),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFeb6d44)),
                                ),
                                onPressed: () {
                                  deletFromAllCookbooks();
                                  Navigator.pop(context);
                                }),
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: TextButton.styleFrom(
                                primary: Color(0xFFeb6d44),
                                backgroundColor: Colors.white,
                                //side: BorderSide(color: Colors.deepOrange, width: 1),
                                elevation: 0,
                                //minimumSize: Size(100, 50),
                                //shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )))
              ],
            );
          });
      // final messages = await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(FirebaseAuth.instance.currentUser.uid)
      //     .collection("cookbooks")
      //     .get();

      // for (var message in messages.docs) {
      //   print("-------------------------------- L -------------");
      //   print(message.data());
      // }
    } else {
      ////delet from specifec or all( ,cancel)
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            title: Column(
              children: [
                Text(
                  'Are you sure to delete the recipe?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, right: 30, left: 30, bottom: 0),
                      child: Column(
                        children: [
                          ElevatedButton(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: [
                                      Center(
                                          child: Icon(
                                              Icons.delete_outline_rounded)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 9),
                                          child: Text(
                                            "All cookbooks",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFeb6d44)),
                              ),
                              onPressed: () {
                                deletFromAllCookbooks();
                                Navigator.pop(context);
                              }),
                          TextButton(
                            child: Text(
                              "This cookbook",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: TextButton.styleFrom(
                              primary: Color(0xFFeb6d44),
                              backgroundColor: Colors.white,
                              //side: BorderSide(color: Colors.deepOrange, width: 1),
                              elevation: 0,
                              //minimumSize: Size(100, 50),
                              //shadowColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              deletFromThisCookbook();
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: TextButton.styleFrom(
                              primary: Color(0xFFeb6d44),
                              backgroundColor: Colors.white,
                              //side: BorderSide(color: Colors.deepOrange, width: 1),
                              elevation: 0,
                              //minimumSize: Size(100, 50),
                              //shadowColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )))
            ],
          );
        },
      );
      print(widget.cookbook);
    }
  }
//---------------deletFromThisCookbook---------

  void deletFromAllCookbooks() {
    List b2 = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cookbooks")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach(
        (result1) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("cookbooks")
              .doc(result1.id)
              .get()
              .then((document) {
            if (document != null) {
              Map<String, dynamic>? data = document.data();
              if (data != null) {
                Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
                if (document.data() != null) {
                  //b2 = document.data()!["bookmarkedList"];
                  b2 = List.from(bookmarkedRecipe.bookmarkedList!);
                }
              }
              if (b2.contains(widget.recipeid)) {
                print("-----------------------------ghada2");
                print(widget.recipeid);
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("cookbooks")
                    .doc(result1.id)
                    .update({
                  "bookmarkedList": FieldValue.arrayRemove([widget.recipeid])
                });
              }
            }
          });
        },
      );
      if (bookmarkCounter == 1 &&
          mealPlanCounter == 0 &&
          widget.autherId == "user delete this recipe") {
        FirebaseFirestore.instance
            .collection("recipes")
            .doc(widget.recipeid)
            .delete();
        Navigator.pop(context);
      } else {
        FirebaseFirestore.instance
            .collection("recipes")
            .doc(widget.recipeid)
            .update({
          "bookmarkCounter": bookmarkCounter - 1,
        });
        Navigator.pop(context);
      }
      setState(() {
        bookmarkCounter--;
        recipeExist = false;
        _bookmarkedList = [];
      });
    });
  }

  void deleteRecipe() {
    if (bookmarkCounter <= 0 && mealPlanCounter <= 0) {
      FirebaseFirestore.instance
          .collection("recipes")
          .doc(widget.recipeid)
          .delete();
    } else {
      FirebaseFirestore.instance
          .collection("recipes")
          .doc(widget.recipeid)
          .update({
        "user_id": "user delete this recipe",
        "is_public_recipe": false,
        "img1":
            "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43",
        "image_count": 1,
      });
    }
  }

  AlertDialog deleteRecipeAleart() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: Column(
        children: [
          Text(
            'Are you sure to delete the recipe?',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, right: 30, left: 30, bottom: 0),
                child: Column(
                  children: [
                    ElevatedButton(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              children: [
                                Center(
                                    child: Icon(Icons.delete_outline_rounded)),
                                SizedBox(
                                  width: 2,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    child: Text(
                                      "Delete ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFeb6d44)),
                        ),
                        onPressed: () {
                          deleteRecipe();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPages()));
                        }),
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: TextButton.styleFrom(
                        primary: Color(0xFFeb6d44),
                        backgroundColor: Colors.white,
                        //side: BorderSide(color: Colors.deepOrange, width: 1),
                        elevation: 0,
                        //minimumSize: Size(100, 50),
                        //shadowColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )))
      ],
    );
  }

  void deletFromThisCookbook() {
    List b2 = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cookbooks")
        .doc(widget.cookbook)
        .get()
        .then((document) {
      if (document != null) {
        Map<String, dynamic>? data = document.data();
        if (data != null) {
          Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
          if (document.data() != null) {
            //b2 = document.data()!["bookmarkedList"];
            b2 = List.from(bookmarkedRecipe.bookmarkedList!);
          }
        }
        if (b2.contains(widget.recipeid)) {
          print("-----------------------------ghada2");
          print(widget.recipeid);
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("cookbooks")
              .doc(widget.cookbook)
              .update({
            "bookmarkedList": FieldValue.arrayRemove([widget.recipeid])
          });
        }
      }
    });

    setState(() {
      recipeExist = false;
      _bookmarkedList = [];
    });
  }

//---------------------------------

  //setState(() {});

  //---------------------------------- t1 --------------------------------------------------------------

  void initState() {
    super.initState();
    getData();
    print('================================');
    print(recipeName);
    print('================================');
    //we call the method here to get the data immediately when init the page.
    if (widget.isFromMealPlan) {
      setState(() {
        MealPlansService.checkRecipeIsAdded(
                mealDay: widget.mealDay,
                mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                recipeID: widget.recipeid)
            .then((value) {
          if (value) {
            setState(() {
              addRecipeToMealPlanButtonStatus =
                  "Remove the recipe to my mealplans";
              addRecipeToMealPlanButtonColor = AppColors.lightGrey;
            });
          } else {
            setState(() {
              addRecipeToMealPlanButtonStatus =
                  "Add the recipe to my mealplans";
              addRecipeToMealPlanButtonColor = AppColors.primaryColor;
            });
          }
        });
      });
    }
  }

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(widget.recipeid)
        // .snapshots()
        // .listen((userData) {
        .get()
        .then((document) {
      if (document != null) {
        Map<String, dynamic>? data = document.data();
        if (data != null) {
          Recipe recipe = Recipe.fromJson(data);
          recipeName = recipe.recipeTitle;
          typeOfMeal = recipe.typeOfMeal;
          category = recipe.category;
          cuisine = recipe.cuisine;
          bookmarkCounter = recipe.bookmarkCounter ?? 0;
          mealPlanCounter = recipe.mealPlanCounter ?? 0;
          widget.autherId = recipe.userId;
          // recipe_image_url = recipe['recipe_image_url'],

          lengthOfIngredients = recipe.lengthOfIngredients;
          lengthOfDirections = recipe.lengthOfDirections;
          lengthOfImages = recipe.imageCount;

          for (int i = 0; i < lengthOfIngredients!; i++) {
            ingredients.add(data['ing${i + 1}']);
          }
          for (int i = 0; i < lengthOfDirections!; i++) {
            dirctions.add(data['dir${i + 1}']);
          }
          for (int i = 0; i < lengthOfImages!; i++) {
            imageUrls.add(data['img${i + 1}']);
          }
        }
      }
    });
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("cookbooks")
    //     .doc("All bookmarked recipes")
    //     .get()
    //     .then((document) {
    //   if (document != null) {
    //     // print('rating data: ${document.data()}');
    //     //usersAlredyRate.clear();
    //     Map<String, dynamic>? data = document.data();

    //     if (data != null) {
    //       print("--------------------------------------4444---------");
    //       Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
    //       print(bookmarkedRecipe.id);

    //       _bookmarkedList = List.from(bookmarkedRecipe.bookmarkedList!);
    //       print(_bookmarkedList[0]);
    //     }
    //   }
    // });
    isLoading = false;
    setState(() {});
    print("//-----------------------------3333333----------------------------");
    // print(_bookmarkedList[0]);
  }

  String addRecipeToMealPlanButtonStatus = "Add the recipe to my mealplans";
  Color addRecipeToMealPlanButtonColor = AppColors.primaryColor;
  Widget buttonAddRecipeToMealPlan() {
    return
//  FloatingActionButtonLocation.centerFloat,

        isAddRecipeToMealPlanLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFeb6d44),
                  color: Colors.white,
                ),
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  //_________________________________________________________________
//Add implementation
                  //_________________________________________________________________
                  setState(() {
                    isAddRecipeToMealPlanLoading = true;
                    setState(() {
                      MealPlansService.checkRecipeIsAdded(
                              mealDay: widget.mealDay,
                              mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                              recipeID: widget.recipeid)
                          .then((value) {
                        if (!value) {
                          setState(() {
                            mealPlanCounter++;
                          });

//MealPlansService.addRecipeToMealPlanDatabase()
                          MealPlansService.addRecipeToMealPlanDatabase(
                                  mealDay: widget.mealDay,
                                  mealPlanTypeOfMeal: widget.mealPlanTypeOfMeal,
                                  recipeID: widget.recipeid)
                              .then((value) => {
                                    isAddRecipeToMealPlanLoading = false,

                                    AddNewMealPlanState.activeStepIndex = 1,
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainPages())),
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           AddNewMealPlan("", "")),
                                    //   (Route<dynamic> route) => false,
                                    // ),
                                    // Navigator.of(context)
                                    //     .popUntil((_) => count++ >= 2)
                                  });

                          AddNewMealPlanState.getRecipeIDAfterAddRecipe(
                            day: widget.mealDay!,
                            typeOfMeal: widget.mealPlanTypeOfMeal!,
                          );

                          setState(() {
                            addRecipeToMealPlanButtonStatus =
                                "Remove the recipe to my mealplans";
                            addRecipeToMealPlanButtonColor =
                                AppColors.lightGrey;
                          });
                        } else {
                          setState(() {
                            mealPlanCounter--;
                          });

                          MealPlansService.deleteRecipeFromMealPlanDatabase(
                              widget.mealDay,
                              widget.mealPlanTypeOfMeal,
                              widget.recipeid);
                          // delete
                          setState(() {
                            isAddRecipeToMealPlanLoading = false;
                            addRecipeToMealPlanButtonStatus =
                                "Add the recipe to my mealplans";
                            addRecipeToMealPlanButtonColor =
                                AppColors.primaryColor;
                          });
                        }
                      });
                    });
                    // if (addRecipeToMealPlanButtonStatus ==
                    //     "Add the recipe to my mealplans")
                  });
                },
                label: Text(addRecipeToMealPlanButtonStatus),
                backgroundColor: addRecipeToMealPlanButtonColor
                //Color(0xFFeb6d44),
                );
  }

  bool isAddRecipeToMealPlanLoading = false;

  Widget floatingButtonWithMealCondtion() {
    return ExpandableFab(
      initialOpen: false,
      //distance: 120,
      children: [
        //---------------to view action button rating and open smale windo to get the rate ---------------------
        RatingRecipe(
          recipeId: widget.recipeid,
          autherId: widget.autherId,
          onRating: (status) {
            print('status is $status');
            if (status == true) {
              // referesh the page after rating
              setState(() {});
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeView(
                      recipeid: widget.recipeid,
                      autherId: widget.autherId,
                      isFromMealPlan: widget.isFromMealPlan,
                    ),
                  ));
            }
          },
        ),

        //-------------comments button to open comment page -------------
        ActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Comments(widget.recipeid, widget.autherId)));
          },
          icon: const Icon(Icons.comment_sharp),
        ),
        //-------------------------------------------------------
      ],
    );
  }

//------------
  @override
  Widget build(BuildContext context) {
    // to return the default image if user does not enter an image by puting "noImageUrl" in the database and converting here to an image
    // final image = widget._mainImageUrl == "noImageUrl" ||
    //         widget._mainImageUrl.isEmpty ||
    //         widget._mainImageUrl == null
    //     ? AssetImage("assets/images/defaultRecipeImage.png")
    //     : NetworkImage(widget._mainImageUrl);

    //----titles of buttons that inside floting button-----

    return Scaffold(
      // ignore: unnecessary_new
      appBar: new AppBar(
        title: Text(recipeName ?? ''),
        backgroundColor: Color(0xFFeb6d44),
        actions: [
          Row(
            children: [
              if (!widget.isFromMealPlan) bookmarkIcon(),
              if (!widget.isFromMealPlan)
                IconButton(
                    icon: Icon(
                      Icons.ios_share_outlined,
                      //  Icons.ios_share,
                      size: 26,
                    ),
                    onPressed: () {
                      //setstat :change the kind of ici=on and add it to bookmark list
                    }),
              widget.autherId == AppGlobals.userId
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        //  Icons.ios_share,
                        size: 26,
                      ),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return deleteRecipeAleart();
                          },
                        );
                      }
                      //setstat :change the kind of ici=on and add it to bookmark list
                      )
                  : SizedBox(),
            ],
          ),
        ],
      ),
      //--------------------floating button that contain comment and rating button -------------------------

      floatingActionButtonLocation: widget.isFromMealPlan
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: widget.isFromMealPlan
          ? buttonAddRecipeToMealPlan()
          : floatingButtonWithMealCondtion(),
      body: Container(
        child: isLoading
            ? CustomCircularLoader()
            : recipeName == null
                ? Center(child: Text('No Recipe Found'))
                : ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      //---------------------images ---------------

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          // CarouselSlider is package used to show many images
                          child: CarouselSlider.builder(
                            itemCount: imageUrls.length,
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              height: 300,
                              reverse: false,
                              aspectRatio: 5.0,
                            ),
                            itemBuilder: (context, i, id) {
                              // print('******************** exception******************');
                              // print(widget._imageUrls[i]);
                              //for onTap to redirect to another screen
                              return GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                      )),
                                  //ClipRRect for image border radius
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      imageUrls[i]!,
                                      width: 500,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  var url = imageUrls[i]!;
                                  print(url.toString());
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      //----------------------------user name and image--------------------
                      // Positioned(
                      //   left: 10,
                      //   top: 10,
                      // child:

                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          getuserinfo(widget.autherId),
//------------------------ Rating of recipe -------------------------------------
                          GetRating(widget.recipeid!, widget.autherId!),
                        ],
                      ),
                      //-------------------------ginral discription ------------------------------------
                      Container(
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //-------------type of meal )-----------
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.restaurant,
                                    color: Colors.grey[600],
                                  ),
                                  Center(
                                      child: Text(
                                    "  " + "${typeOfMeal ?? ''}",
                                  ))
                                ],
                              ),
                            ),
                            //-----------------cuisine---------------
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    color: Colors.grey[600],
                                  ),
                                  Center(
                                    child: Text("  " + "${cuisine ?? ''}"),
                                  )
                                ],
                              ),
                            ),
                            //----------------category---------------
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted,
                                    color: Colors.grey[600],
                                  ),
                                  Center(
                                    child: Text("  " + "${category ?? ''}"),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //--------------------------ingrediants and dirctions--------------------------
                      ConvertTocheckBox(ingredients, "Ingrediants"),
                      ConvertTocheckBox(dirctions, "Dirctions")
                      //-------------------------------------------
                    ],
                  ),
      ),
    );
  }
}

//-------this clas to get rating from data base and display it ------------

class GetRating extends StatefulWidget {
  String? _recipeId;
  String? _autherId;
  GetRating(this._recipeId, this._autherId);
  @override
  GetRatingState createState() => GetRatingState();
}

class GetRatingState extends State<GetRating> {
  int? numOfRevewis = 0;
  double? avg = 0.0;
  var rating;

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        // .collection("users")
        // .doc(widget._autherId)
        .collection("recipes")
        .doc(widget._recipeId)
        .collection("rating")
        .doc("recipeRating")
        // .snapshots()
        // .listen((userData) {
        .get()
        .then((document) {
      Map data = document.data()!;
      numOfRevewis = data["num_of_reviews"];
      avg = data["average_rating"];
      // print("00000---------------------------------------");
      print(avg);
      // print("00000---------------------------------------");
      print(numOfRevewis);
      if (mounted) setState(() {});
    });
  }

  void initState() {
    super.initState();
    getData();

    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Text(
          avg!.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Column(
            children: [
              RatingBarIndicator(
                rating: avg!,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 17.0,
                direction: Axis.horizontal,
              ),
              Text(
                '$numOfRevewis Reviews',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

//----------this class to show user image and name who is adding the recipe -------------

class getuserinfo extends StatefulWidget {
  String? _autherId;

  getuserinfo(this._autherId);
  @override
  getuserinfoState createState() => getuserinfoState();
}

class getuserinfoState extends State<getuserinfo> {
  String? _autherName = "";
  String? _autherimage = "";
  getData() {
    String? _id = widget._autherId; //solve empty exeption
    if (widget._autherId != "user delete this recipe") {
      FirebaseFirestore.instance
          .collection("users")
          .doc("$_id")
          .get()
          .then((userData) {
        Map? user = userData.data();
        if (user != null)
          setState(() {
            _autherName = user['username'];
            _autherimage = user['image_url'];
          });
      });
    } else {
      setState(() {
        _autherName = "user delete this recipe";
        _autherimage = "noImage";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    print("------------------------------");
    print(_autherName);
    return UserInformationDesign(widget._autherId, _autherName,
        _autherimage!); // calling this class to design image and user name after get them from database
  }
}
