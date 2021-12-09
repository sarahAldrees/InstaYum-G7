import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/recipe_view/comment.dart';
import 'package:instayum1/widget/recipe_view/ConvertTocheckBox.dart';
import 'package:instayum1/widget/recipe_view/RatingRecipe.dart';
import 'package:instayum1/widget/recipe_view/UserInformationDesign.dart';
import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';

class RecipeView extends StatelessWidget {
  String _autherId;
  String _recipeid;
  String _recipeName;
  String _imageURL;
  String _typeOfMeal;
  String _category;
  String _cuisine;
  List<String> _ingredients;
  List<String> _dirctions;

  RecipeView(
    //Key,

    this._autherId,
    this._recipeid,
    this._recipeName,
    this._imageURL,
    this._typeOfMeal,
    this._category,
    this._cuisine,
    this._ingredients,
    this._dirctions,
  );
  @override
  Widget build(BuildContext context) {
    // to return the default image if user does not enter an image by puting "noImageUrl" in the database and converting here to an image
    final image =
        _imageURL == "noImageUrl" || _imageURL.isEmpty || _imageURL == null
            ? AssetImage("assets/images/defaultRecipeImage.png")
            : NetworkImage(_imageURL);
    //----titles of buttons that inside floting button-----

    const _actionTitles = [
      'Add ingrediants To Shopoing List',
      'Reating',
      'Add Comment'
    ];

    //-------------
    return Scaffold(
      appBar: new AppBar(
        title: Text(_recipeName),
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
          RatingRecipe(_recipeid, _autherId),
          //-------------comments button to open comment page -------------
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Comments(_recipeid, _autherId)));
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
                      child: Ink.image(
                          image: image, height: 250, fit: BoxFit.cover)
//-----------very importatnt to check which attribute is the best with boxfit ? # delete */
                      ),
                ),
              ],
            ),
          ),
          //----------------------------user name and image--------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getuserinfo(_autherId),
//------------------------ Rating of recipe -------------------------------------
              getRating(_recipeid, _autherId),
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
                        "  " + _typeOfMeal,
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
                      Center(child: Text("  " + _cuisine))
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
                      Center(child: Text("  " + _category))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //--------------------------ingrediants and dirctions--------------------------
          ConvertTocheckBox(_ingredients, "Ingrediants"),

          ConvertTocheckBox(_dirctions, "Dirctions")
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
