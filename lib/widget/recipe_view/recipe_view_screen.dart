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
  String id;
  String recipeName;
  String imageURL;
  String typeOfMeal;
  String category;
  String cuisine;
  List<String> ingredients;
  List<String> dirctions;

  static final commentRef = FirebaseFirestore.instance.collection("comments");
  recipe_view(
      //Key,
      this.autherName,
      this.autherImage,
      this.id,
      this.recipeName,
      this.imageURL,
      this.typeOfMeal,
      this.category,
      this.cuisine,
      this.ingredients,
      this.dirctions);
  @override
  Widget build(BuildContext context) {
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
          Rating_recipe(),
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Comments(
                            userId: recipeName,
                            recipeId: id,
                            comment: imageURL,
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
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.fill,
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
              userinfo(autherName, autherImage),
//------------------------ Rating of recipe -------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text(
                    '4',
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
                            rating: 4,
                            itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            itemCount: 5,
                            itemSize: 17.0,
                            direction: Axis.horizontal),
                        Text(
                          '3 Reviews',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
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
