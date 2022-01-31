import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum1/model/cookbook.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/bookmark/cookbook_item.dart';
import 'package:instayum1/widget/bookmark/cookbook_recipes.dart';
import 'package:instayum1/widget/recipe_view/comment.dart';
import 'package:instayum1/widget/recipe_view/convert_to_check_box.dart';
import 'package:instayum1/widget/recipe_view/rating_recipe.dart';
import 'package:instayum1/widget/recipe_view/user_information_design.dart';
import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instayum1/widget/bookmark/bookmarks_recipes_screen.dart';

class RecipeView extends StatefulWidget {
  String cookbook;
  String _autherId;
  String _recipeid;
  String _recipeName;
  String _mainImageUrl;
  String _typeOfMeal;
  String _category;
  String _cuisine;
  List<String> _ingredients;
  List<String> _dirctions;
  List<String> _imageUrls;

  RecipeView(
    //Key,
    this.cookbook,
    this._autherId,
    this._recipeid,
    this._recipeName,
    this._mainImageUrl,
    this._typeOfMeal,
    this._category,
    this._cuisine,
    this._ingredients,
    this._dirctions,
    this._imageUrls,
  );

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool recipeExist = false;
  bool ishappend = false;

  Widget bookmarkIcon() {
    //cookbook_item.isBrowse = false;
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("cookbooks")
        .doc("All bookmarked recipes")
        .collection("bookmarked_recipe")
        .snapshots()
        .listen((data) {
      if (!ishappend) {
        // setState(() {
        recipeExist = bookmarked_recipes.Saved;
        //});
        //recipeExist = false;

        data.docs.forEach((doc) {
          if (doc.data()['recipeId'] == widget._recipeid) {
            recipeExist = true;
            bookmarked_recipes.Saved = true;
          }
        });
      }
      if (!ishappend && bookmarked_recipes.Saved && this.mounted) {
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
            cookbook_recipes.isNeedUpdate = true;
//-----------------------------------------------------------
          });
    } else {
      setState(() {
        bookmarked_recipes.Saved = false;
      });
      return IconButton(
          icon: Icon(
            Icons.bookmark_add_outlined,
            size: 26,
          ),
          onPressed: () {
            //   setState(() {
            cookbook_item.isBrowse = false;
            bookmarked_recipes.Saved = true;
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
                  return bookmarked_recipes(widget._autherId, widget._recipeid);
                  // return bookmarked_recipes();
                });

            //setstat :change the kind of ici=on and add it to bookmark list
          });
    }
  }

//---------------------------------------- try 1 unbookmark -----------------------------------------------
  void unBookmarkRecipe() async {
    if (!cookbook_item.isBrowse ||
        widget.cookbook == "All bookmarked recipes" ||
        widget.cookbook == "") {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("cookbooks")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result1) {
          final mes = FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection("cookbooks")
              .doc(result1.id)
              .collection("bookmarked_recipe")
              .get();

          mes.then(
            (querySnapshot) {
              querySnapshot.docs.forEach((result) {
                if (result.id == widget._recipeid) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser.uid)
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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("cookbooks")
          .doc(widget.cookbook)
          .collection("bookmarked_recipe")
          .doc(widget._recipeid)
          .delete();

      setState(() {
        recipeExist = false;
        //   ishappend = false;
      });
    }
  }
  //---------------------------------- t1 --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // to return the default image if user does not enter an image by puting "noImageUrl" in the database and converting here to an image
    final image = widget._mainImageUrl == "noImageUrl" ||
            widget._mainImageUrl.isEmpty ||
            widget._mainImageUrl == null
        ? AssetImage("assets/images/defaultRecipeImage.png")
        : NetworkImage(widget._mainImageUrl);
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
        title: Text(widget._recipeName),
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
          RatingRecipe(widget._recipeid, widget._autherId),
          //-------------comments button to open comment page -------------
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Comments(widget._recipeid, widget._autherId)));
            },
            icon: const Icon(Icons.comment_sharp),
          ),
          //-------------------------------------------------------
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          //---------------------images ---------------

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              margin: EdgeInsets.all(15),
              // CarouselSlider is package used to show many images
              child: CarouselSlider.builder(
                itemCount: widget._imageUrls.length,
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
                          widget._imageUrls[i],
                          width: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      var url = widget._imageUrls[i];
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
              getuserinfo(widget._autherId),
//------------------------ Rating of recipe -------------------------------------
              getRating(widget._recipeid, widget._autherId),
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
                        "  " + widget._typeOfMeal,
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
                      Center(child: Text("  " + widget._cuisine))
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
                      Center(child: Text("  " + widget._category))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //--------------------------ingrediants and dirctions--------------------------
          ConvertTocheckBox(widget._ingredients, "Ingrediants"),

          ConvertTocheckBox(widget._dirctions, "Dirctions")
          //-------------------------------------------
        ],
      ),
    );
  }
}

//-------this clas to get rating from data base and display it ------------

class getRating extends StatefulWidget {
  String _recipeId;
  String _autherId;
  getRating(this._recipeId, this._autherId);
  @override
  getRatingState createState() => getRatingState();
}

class getRatingState extends State<getRating> {
  var numOfRevewis;
  var avg = 0.0;
  var rating;

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget._autherId)
        .collection("recipes")
        .doc(widget._recipeId)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      setState(() {
        numOfRevewis = userData.data()["num_of_reviews"];

        avg = userData.data()["average_rating"];
        print("00000---------------------------------------");
        print(avg);
        print("00000---------------------------------------");
        print(numOfRevewis);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Text(
          "$avg",
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
                  rating: avg,
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
  String _autherId;

  getuserinfo(this._autherId);
  @override
  getuserinfoState createState() => getuserinfoState();
}

class getuserinfoState extends State<getuserinfo> {
  String _autherName = "";
  String _autherimage = "";
  getData() async {
    String _id = widget._autherId; //solve empty exeption
    FirebaseFirestore.instance
        .collection("users")
        .doc("$_id")
        .snapshots()
        .listen((userData) {
      setState(() {
        _autherName = userData.data()['username'];

        _autherimage = userData.data()['image_url'];
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
    return UserInformationDesign(_autherName,
        _autherimage); // calling this class to design image and user name after get them from database
  }
}
