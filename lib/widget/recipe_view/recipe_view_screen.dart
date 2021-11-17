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
  //final commentRef = FirebaseFirestore.instance.collection("comments");

  @override
  Widget build(BuildContext context) {
    Recipe a = new Recipe(
      id: 'r1',
      recipeName: 'Pancakes',
      imageURL:
          "https://www.eatthis.com/wp-content/uploads/sites/4/2019/11/whole-grain-pancake-stack.jpg?fit=1200%2C879&ssl=1",
      typeOfMeal: "breakfast",
      category: 'Drinks',
      cuisine: "indian",
      ingredients: ["ggggg", "dsdsad", "asdasda", "ggggg", "dsdsad", "asdasda"],
      dirctions: ["aaa", "dsdsad", "asdasda"],
    );

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
        title: Text(a.recipeName),
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
                      builder: (context) => Comment(
                            recipeId: a.id,
                            userId: a.recipeName,
                            msg: a.imageURL,
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
                    a.imageURL,
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
              userinfo(),
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
                        "  " + a.typeOfMeal,
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
                      Center(child: Text("  " + a.cuisine))
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
                      Center(child: Text("  " + a.category))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //--------------------------ingrediants--------------------------
          convertTocheckBox(a.ingredients, "Ingrediants"),

          convertTocheckBox(a.dirctions, "Dirctions")
          //-------------------------------------------
        ],
      ),
    ); //Row(
    //   children: [ingrediants(a.ingredients), ingrediants(a.dirctions)],
  } //outvalue is change the state of check list
}

//-------------------
