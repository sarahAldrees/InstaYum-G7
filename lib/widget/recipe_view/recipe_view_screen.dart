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
  String autherName;
  String autherImage;
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
    // this.autherName,
    // this.autherImage,
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
    //---------

    const _actionTitles = [
      'Add ingrediants To Shopoing List',
      'Reating',
      'Add Comment'
    ];
    // void _showAction(BuildContext context, int index) {
    //   showDialog<void>(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(_actionTitles[index]),
    //       );
    //     },
    //   );
    // }

    //--------------

    //-------------
    return Scaffold(
      appBar: new AppBar(
        title: Text(recipeName),
        backgroundColor: Color(0xFFeb6d44),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        children: [
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag),
          ),
          Rating_recipe(recipeid, autherId),
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Comments(
                            recipeId: recipeid,
                            authorId: autherId,
                            //comment: imageURL,
                          )));
            },
            icon: const Icon(Icons.comment_sharp),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          //---------------------image and bookmarked and shear button---------------
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Stack(
              children: [
                ClipRRect(
                  child: Material(
                      color: Colors.white,
                      child:
                          Ink.image(image: image, height: 250, fit: BoxFit.fill)
                      //************************************8 very importatnt to check which attribute is the best with boxfit ? # delete */
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
                            //setstat :change the kind of ici=on and add it to bookmark list
                          }),
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(children: [
              //     Text(
              //       '4',
              //       style: TextStyle(
              //         fontSize: 26,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 6),
              //       child: Column(
              //         children: [
              //           RatingBarIndicator(
              //               rating: 4,
              //               itemBuilder: (context, index) => Icon(
              //                     Icons.star,
              //                     color: Colors.amber,
              //                   ),
              //               itemCount: 5,
              //               itemSize: 17.0,
              //               direction: Axis.horizontal),
              //           Text(
              //             '3 Reviews',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ]),
              // ),
              //userinfo(),
            ],
          ),
          //-------------------------ginral discription ------------------------------------
          Container(
            margin: EdgeInsets.only(bottom: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                //--------------------------------
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.public,
                        color: Colors.grey[600],
                      ),
                      // Text(
                      //   "|",
                      //   style: TextStyle(
                      //       fontSize: 30,
                      //       color: Colors.grey[600],
                      //       fontWeight: FontWeight.w100),
                      // ),
                      Center(child: Text("  " + cuisine))
                    ],
                  ),
                ),
                // Text(a.category),
                // Text(a.cuisine),
                // Text(a.typeOfMeal),
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_list_bulleted,
                        color: Colors.grey[600],
                      ),
                      // Text(
                      //   "|",
                      //   style: TextStyle(
                      //       fontSize: 30,
                      //       color: Colors.grey[600],
                      //       fontWeight: FontWeight.w100),
                      // ),
                      Center(child: Text("  " + category))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //--------------------------ingrediants--------------------------
          convertTocheckBox(ingredients, "Ingrediants"),

          convertTocheckBox(dirctions, "Dirctions")
          //-------------------------------------------
        ],
      ),
    ); //Row(
    //   children: [ingrediants(a.ingredients), ingrediants(a.dirctions)],
  } //outvalue is change the state of check list
}

//-------------------

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
        .collection("recpies")
        .doc(widget.recipeId)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      setState(() {
        numOfRevewis = userData.data()["no_of_pepole"];

        avg = userData.data()["average_rating"];
      });
    });
  }

  void initState() {
    print("00000---------------------------------------");

    print(numOfRevewis);
    setState(() {
      numOfRevewis;
      avg;
    });
    super.initState();
    getData();
    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   numOfRevewis;
    //   avg;
    // });
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

        // print(avg);
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
    return userinfo(autherName, autherimage);
  }
}
