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
import 'package:instayum/widget/recipe_view/share_recipe.dart';
import 'package:share_plus/share_plus.dart';
import 'package:instayum/widget/recipe_view/comment.dart';
import 'package:instayum/widget/recipe_view/convert_to_check_box.dart';
import 'package:instayum/widget/recipe_view/rating_recipe.dart';
import 'package:instayum/widget/recipe_view/user_information_design.dart';
import 'package:instayum/widget/recipe_view/view_reicpe_flotingbutton.dart';

import '../../constant/app_colors.dart';
import '../discover/top_recipes/top_recipe_service.dart';
import '../meal_plan/add_new_mealplan.dart';
import '../meal_plan/mealplan_service.dart';

class RecipeView extends StatefulWidget {
  String? cookbook;
  String? autherId;
  String? recipeid;
  bool isFromMealPlan = false;
  String? mealDay;
  String? mealPlanTypeOfMeal;

  RecipeView({
    Key? key,
    this.cookbook,
    this.autherId,
    required this.recipeid,
    required this.isFromMealPlan,
    this.mealDay,
    this.mealPlanTypeOfMeal,
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
  //------------text for sharing--------
  String sharedIngredients = "";
  String sharedDirctions = "";
  //-------------------------------------------------

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
          Map<String, dynamic>? data = document.data();

          if (data != null) {
            Cookbook bookmarkedRecipe = Cookbook.fromJson(data);

            _bookmarkedList = List.from(bookmarkedRecipe.bookmarkedList!);
            if (!_bookmarkedList.isEmpty)
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

    if (recipeExist) {
      return IconButton(
          icon: Icon(
            Icons.bookmark,
            size: 26,
          ),
          onPressed: () {
            //------------------delete from bookmark recipe--------------
            removeBookmarkedRecipes();

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
            CookbookItem.isBrowse = false;
            BookmarkedRecipes.Saved = true;

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
                });

            FirebaseFirestore.instance
                .collection("recipes")
                .doc(widget.recipeid)
                .update({
              "bookmarkCounter": bookmarkCounter + 1,
            });
            TopRecipeService().addToWeeklyTopBookmarks(
              recipeId: widget.recipeid,
              userId: AppGlobals.userId,
            );
            setState(() {
              ++bookmarkCounter;
              recipeExist = true;
            });
          });
    }
  }

//---------------------------------------- try 1 unbookmark -----------------------------------------------
  void removeBookmarkedRecipes() {
    recipeExist = false;
    if (widget.cookbook == "All bookmarked recipes" ||
        widget.cookbook == "" ||
        widget.cookbook == null) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            title: Center(
              child: Text(
                'Remove bookmarked recipe',
                style: TextStyle(
                    fontSize: 19, color: Theme.of(context).accentColor),
              ),
            ),
            content: Text(
              'Are you sure to remove the recipe from all cookbooks?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      color: Color(0xFFeb6d44),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        deletFromAllCookbooks();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            title: Center(
              child: Text(
                'Remove bookmarked recipe',
                style: TextStyle(
                    fontSize: 19, color: Theme.of(context).accentColor),
              ),
            ),
            content: Text(
              'You want to remove the recipe from',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    RaisedButton(
                      color: Color(0xFFeb6d44),
                      child: Text(
                        "   From all cookbooks   ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        deletFromAllCookbooks();
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "        This cookbook        ",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () {
                        deletFromThisCookbook();
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "             Cancel               ",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
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
                  b2 = List.from(bookmarkedRecipe.bookmarkedList!);
                }
              }
              if (b2.contains(widget.recipeid)) {
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

        TopRecipeService().removeFromWeeklyTopBookmarks(
          recipeId: widget.recipeid,
          userId: AppGlobals.userId,
        );

        if (widget.cookbook != "") Navigator.pop(context);
      }
      if (mounted)
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
            b2 = List.from(bookmarkedRecipe.bookmarkedList!);
          }
        }
        if (b2.contains(widget.recipeid)) {
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
    Navigator.pop(context);
    setState(() {
      recipeExist = false;
      _bookmarkedList = [];
    });
  }

//---------------------------------

  //---------------------------------- t1 --------------------------------------------------------------

  void initState() {
    super.initState();
    getData();

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
                  "Remove the recipe from meal plan";
              addRecipeToMealPlanButtonColor = AppColors.lightGrey;
              textColor = Colors.white;
            });
          } else {
            setState(() {
              addRecipeToMealPlanButtonStatus =
                  "Add the recipe to my meal plan";

              textColor = Color(0xFFeb6d44);
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

          lengthOfIngredients = recipe.lengthOfIngredients;
          lengthOfDirections = recipe.lengthOfDirections;
          lengthOfImages = recipe.imageCount;
          sharedIngredients = "";
          sharedDirctions = "";

          for (int i = 0; i < lengthOfIngredients!; i++) {
            ingredients.add(data['ing${i + 1}']);
            sharedIngredients =
                sharedIngredients + "-" + data['ing${i + 1}'] + "\n";
          }
          for (int i = 0; i < lengthOfDirections!; i++) {
            dirctions.add(data['dir${i + 1}']);
            sharedDirctions = sharedDirctions + data['dir${i + 1}'] + "\n";
          }
          for (int i = 0; i < lengthOfImages!; i++) {
            imageUrls.add(data['img${i + 1}']);
          }
        }
      }
    });

    isLoading = false;
    setState(() {});
  }

  String addRecipeToMealPlanButtonStatus = "Add the recipe to my meal plan";
  Color addRecipeToMealPlanButtonColor = Colors.grey[350]!;
  Color textColor = Color(0xFFeb6d44);
  Widget buttonAddRecipeToMealPlan() {
    return isAddRecipeToMealPlanLoading
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFFeb6d44),
              color: Colors.white,
            ),
          )
        : FloatingActionButton.extended(
            onPressed: () {
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
                              });

                      AddNewMealPlanState.getRecipeIDAfterAddRecipe(
                        day: widget.mealDay!,
                        typeOfMeal: widget.mealPlanTypeOfMeal!,
                      );

                      setState(() {
                        addRecipeToMealPlanButtonStatus =
                            "Remove the recipe from meal plan";
                        addRecipeToMealPlanButtonColor = AppColors.lightGrey;
                        textColor = Colors.white;
                        appPages.isMealPlanClicked = true;
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
                            "Add the recipe to my meal plan";
                        appPages.isMealPlanClicked = true;
                        addRecipeToMealPlanButtonColor = Colors.grey[350]!;
                        textColor = Color(0xFFeb6d44);
                      });
                    }
                  });
                });
              });
            },
            label: Text(
              addRecipeToMealPlanButtonStatus,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            backgroundColor: addRecipeToMealPlanButtonColor,
            elevation: 10,
          );
  }

  bool isAddRecipeToMealPlanLoading = false;

  Widget floatingButtonWithoutMealCondtion() {
    return widget.autherId != "user delete this recipe"
        ? ExpandableFab(
            initialOpen: true,
            children: [
              //---------------to view action button rating and open smale windo to get the rate ---------------------
              RatingRecipe(
                recipeId: widget.recipeid,
                autherId: widget.autherId,
                onRating: (status) {
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
          )
        : SizedBox();
  }

//------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      size: 26,
                    ),
                    onPressed: () {
                      ShareRecipeService().createAndShareLink(
                        title: recipeName,
                        ingredients: sharedIngredients,
                        dirctions: sharedDirctions,
                        recipeId: widget.recipeid,
                        userId: widget.autherId,
                      );
                    }),
              if (!widget.isFromMealPlan)
                widget.autherId == AppGlobals.userId
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 26,
                        ),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                title: Text(
                                  'Delete recipe ',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Theme.of(context).accentColor),
                                ),
                                content: Text(
                                  'Are you sure to delete this recipe?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RaisedButton(
                                    color: Color(0xFFeb6d44),
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      deleteRecipe();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainPages()));
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        })
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
          : floatingButtonWithoutMealCondtion(),
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
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      //----------------------------user name and image--------------------

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          getuserinfo(widget.autherId),
//------------------------ Rating of recipe -------------------------------------
                          GetRating(widget.recipeid!, widget.autherId),
                        ],
                      ),
                      //-------------------------ginral discription ------------------------------------
                      Container(
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //-------------type of meal -----------
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

//-------this class to get rating from data base and display it ------------

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
        .collection("recipes")
        .doc(widget._recipeId)
        .collection("rating")
        .doc("recipeRating")
        .get()
        .then((document) {
      Map data = document.data()!;
      numOfRevewis = data["num_of_reviews"];
      avg = data["average_rating"];
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
    return UserInformationDesign(widget._autherId, _autherName,
        _autherimage!); // calling this class to design image and user name after get them from database
  }
}
