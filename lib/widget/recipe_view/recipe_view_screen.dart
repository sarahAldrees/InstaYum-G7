import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/recipe_view/comment_model.dart';
import 'package:instayum1/widget/recipe_view/convert_to_checkboxList.dart';
import 'package:instayum1/widget/recipe_view/image_and_username.dart';
import 'package:instayum1/widget/recipe_view/rating_recipe.dart';
import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';

class recipe_view extends StatelessWidget {
  String autherId;
  String recipeid;
  String recipeName;
  String imageURL;
  String typeOfMeal;
  String category;
  String cuisine;
  List<String> ingredients;
  List<String> dirctions;

  recipe_view(
    //Key,

    this.autherId,
    this.recipeid,
    this.recipeName,
    this.imageURL,
    this.typeOfMeal,
    this.category,
    this.cuisine,
    this.ingredients,
    this.dirctions,
  );
  @override
  Widget build(BuildContext context) {
    // to return the default image if user does not enter an image by puting "noImageUrl" in the database and converting here to an image
    final image =
        imageURL == "noImageUrl" || imageURL.isEmpty || imageURL == null
            ? AssetImage("assets/images/defaultRecipeImage.png")
            : NetworkImage(imageURL);
    //----titles of buttons that inside floting button-----

    const _actionTitles = [
      'Add ingrediants To Shopoing List',
      'Reating',
      'Add Comment'
    ];

    //-------------
    return Scaffold(
      appBar: new AppBar(
        title: Text(recipeName),
        backgroundColor: Color(0xFFeb6d44),
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
          Rating_recipe(recipeid, autherId),
          //-------------comments button to open comment page -------------
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Comments(
                            recipeId: recipeid,
                            authorId: autherId,
                          )));
            },
            icon: const Icon(Icons.comment_sharp),
          ),
          //-------------------------------------------------------
        ],
      ),
      body: ListView(
        children: <Widget>[
          //---------------------image with bookmarked and shear button---------------
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Stack(
              children: [
                ClipRRect(
                  child: Material(
                      color: Colors.white,
                      child:
                          Ink.image(image: image, height: 250, fit: BoxFit.fill)
//-----------very importatnt to check which attribute is the best with boxfit ? # delete */
                      ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            size: 26,
                            // color: Color(0xFFeb6d44),
                          ),
                          onPressed: () {
                            //setstat :change the kind of icon and add it to bookmark list
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.ios_share_outlined,
                            //  Icons.ios_share,
                            size: 26,
                          ),
                          onPressed: () {
                            // to share to other
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //----------------------------user name and image--------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getuserinfo(autherId),
//------------------------ Rating of recipe -------------------------------------
              gitRating(recipeid, autherId),
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
                        "  " + typeOfMeal,
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
                      Center(child: Text("  " + cuisine))
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
                      Center(child: Text("  " + category))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //--------------------------ingrediants and dirctions--------------------------
          convertTocheckBox(ingredients, "Ingrediants"),

          convertTocheckBox(dirctions, "Dirctions")
          //-------------------------------------------
        ],
      ),
    );
  }
}

//-------this clas to get rating from data base and display it ------------

class gitRating extends StatefulWidget {
  String recipeId;
  String autherId;
  gitRating(this.recipeId, this.autherId);
  @override
  getRatingState createState() => getRatingState();
}

var numOfRevewis;
var avg = 0.0;
var rating;

class getRatingState extends State<gitRating> {
  getData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.autherId)
        .collection("recipes")
        .doc(widget.recipeId)
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
  String autherId;

  getuserinfo(this.autherId);
  @override
  getuserinfoState createState() => getuserinfoState();
}

class getuserinfoState extends State<getuserinfo> {
  String autherName = "";
  String autherimage = "";
  getData() async {
    String id = widget.autherId; //solve empty exeption
    FirebaseFirestore.instance
        .collection("users")
        .doc("$id")
        .snapshots()
        .listen((userData) {
      setState(() {
        autherName = userData.data()['username'];

        autherimage = userData.data()['image_url'];
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
    return userinfo(autherName,
        autherimage); // calling this class to design image and user name after get them from database
  }
}
