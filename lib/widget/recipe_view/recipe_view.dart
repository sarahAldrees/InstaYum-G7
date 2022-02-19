import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/model/recipe.dart';
import 'package:instayum/widget/bookmark/bookmarks_recipes_screen.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';
import 'package:instayum/widget/bookmark/cookbook_recipes.dart';
import 'package:instayum/widget/profile/circular_loader.dart';
import 'package:instayum/widget/recipe_view/comment.dart';
import 'package:instayum/widget/recipe_view/convert_to_check_box.dart';
import 'package:instayum/widget/recipe_view/rating_recipe.dart';
import 'package:instayum/widget/recipe_view/user_information_design.dart';
import 'package:instayum/widget/recipe_view/view_reicpe_flotingbutton.dart';
// import 'package:instayum1/widget/bookmark/cookbook_item.dart';
// import 'package:instayum1/widget/bookmark/cookbook_recipes.dart';
// import 'package:instayum1/widget/recipe_view/comment.dart';
// import 'package:instayum1/widget/recipe_view/convert_to_check_box.dart';
// import 'package:instayum1/widget/recipe_view/rating_recipe.dart';
// import 'package:instayum1/widget/recipe_view/user_information_design.dart';
// import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:instayum1/widget/bookmark/bookmarks_recipes_screen.dart';

class RecipeView extends StatefulWidget {
  String? cookbook;
  String? autherId;
  String? recipeid;
  // String _recipeName;
  // String _mainImageUrl;
  // String _typeOfMeal;
  // String _category;
  // String _cuisine;
  // List<String> _ingredients;
  // List<String> _dirctions;
  // List<String> _imageUrls;

  RecipeView(
    // Key? key,
    this.cookbook,
    this.autherId,
    this.recipeid, {String? cookbook, String? autherId},
    // this._recipeName,
    // this._mainImageUrl,
    // this._typeOfMeal,
    // this._category,
    // this._cuisine,
    // this._ingredients,
    // this._dirctions,
    // this._imageUrls,
  );

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

  //-------------------------------------------------
  bool recipeExist = false;
  bool ishappend = false;

  Widget bookmarkIcon() {
    //cookbook_item.isBrowse = false;
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cookbooks")
        .doc("All bookmarked recipes")
        .collection("bookmarked_recipe")
        .snapshots()
        .listen((data) {
      if (!ishappend) {
        // setState(() {
        recipeExist = BookmarkedRecipes.Saved;
        //});
        //recipeExist = false;

        data.docs.forEach((doc) {
          if (doc.data()['recipeId'] == widget.recipeid) {
            recipeExist = true;
            BookmarkedRecipes.Saved = true;
          }
        });
      }
      if (!ishappend && BookmarkedRecipes.Saved && this.mounted) {
        ishappend = recipeExist;
        // bookmarked_recipes.Saved = true;
        setState(() {});
      }
      // if (!recipeExist) {
      //   setState(() {
      //     ishappend = recipeExist;
      //   });
      // }
    });

    print(recipeExist);
    if (recipeExist) {
      return IconButton(
          icon: Icon(
            Icons.bookmark,
            //  Icons.ios_share,
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
            //   setState(() {
            CookbookItem.isBrowse = false;
            BookmarkedRecipes.Saved = true;
            // });

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
                  return BookmarkedRecipes(widget.autherId!, widget.recipeid!);
                  // return bookmarked_recipes();
                });

            //setstat :change the kind of ici=on and add it to bookmark list
          });
    }
  }

//---------------------------------------- try 1 unbookmark -----------------------------------------------
  void unBookmarkRecipe() {
    recipeExist = false;
    if (widget.cookbook == "All bookmarked recipes" || widget.cookbook == "") {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cookbooks")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result1) {
          final mes = FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("cookbooks")
              .doc(result1.id)
              .collection("bookmarked_recipe")
              .get();

          mes.then(
            (querySnapshot) {
              querySnapshot.docs.forEach((result) {
                if (result.id == widget.recipeid) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("cookbooks")
                      .doc(result1.id)
                      .collection("bookmarked_recipe")
                      .doc(result.id)
                      .delete();
                  print(result.id);
                }

                //     for(var result1 in querySnapshot.docs){
                //       if(querySnapshot.doc )
                //     //  FirebaseFirestore.instance
                // // .collection("bookmarked_recipe").doc().delete();
                //                 }
              });
            },
          );
          setState(() {
            recipeExist = false;
            ishappend = false;
            CookbookRecipes.isNeedUpdate = true;
          });
        });
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
      print(widget.cookbook);
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cookbooks")
          .doc(widget.cookbook)
          .collection("bookmarked_recipe")
          .doc(widget.recipeid)
          .delete();
      setState(() {
        recipeExist = false;
        CookbookRecipes.isNeedUpdate = true;
        //ishappend = false;
      });
    }
    //setState(() {});
  }
  //---------------------------------- t1 --------------------------------------------------------------
//-----------------

  void initState() {
    super.initState();
    getData();
    //we call the method here to get the data immediately when init the page.
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
    isLoading = false;
    setState(() {});
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
    const _actionTitles = [
      'Add ingrediants To Shopoing List',
      'Reating',
      'Add Comment'
    ];

    //-------------
    return Scaffold(
      // ignore: unnecessary_new
      appBar: new AppBar(
        title: Text(recipeName ?? ''),
        backgroundColor: Color(0xFFeb6d44),
        actions: [
          Row(
            children: [
              bookmarkIcon(),
              IconButton(
                  icon: Icon(
                    Icons.ios_share_outlined,
                    //  Icons.ios_share,
                    size: 26,
                  ),
                  onPressed: () {
                    //setstat :change the kind of ici=on and add it to bookmark list
                  }),
            ],
          ),
        ],
      ),
      //--------------------floating button that contain comment and rating button -------------------------
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        children: [
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag),
          ),
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
                          Comments(widget.recipeid!, widget.autherId!)));
            },
            icon: const Icon(Icons.comment_sharp),
          ),
          //-------------------------------------------------------
        ],
      ),
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
                          getuserinfo(widget.autherId!),
//------------------------ Rating of recipe -------------------------------------
                          getRating(widget.recipeid!, widget.autherId!),
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

class getRating extends StatefulWidget {
  String? _recipeId;
  String? _autherId;
  getRating(this._recipeId, this._autherId);
  @override
  getRatingState createState() => getRatingState();
}

class getRatingState extends State<getRating> {
  int? numOfRevewis = 0;
  double? avg = 0.0;
  var rating;

  getData() async {
    //to get previous rating info from firestor
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
      setState(() {});
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
                  direction: Axis.horizontal),
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
  getData() async {
    String? _id = widget._autherId; //solve empty exeption
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
  }

  void initState() {
    super.initState();
    getData();

    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    return UserInformationDesign(_autherName!,
        _autherimage!); // calling this class to design image and user name after get them from database
  }
}
