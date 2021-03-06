import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class RecipeCard extends StatefulWidget {
  final String? autherId;
  final String? RecipeId;
  final String? recipeName;
  final String? typeOfMeal;
  final String? category;
  final String? mainImageURL;
  final String? cuisine;
  final List<String?>? ingredients;
  final List<String?>? dirctions;
  final List<String?>? imageUrls;

  RecipeCard(
    this.autherId,
    this.RecipeId,
    this.recipeName,
    this.mainImageURL,
    this.typeOfMeal,
    this.category,
    this.cuisine,
    this.ingredients,
    this.dirctions,
    this.imageUrls,
  );

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  var numOfRevewis;
  var avg = 0.0;
  var rating = '0';

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(widget.RecipeId)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      if (mounted)
        setState(() {
          numOfRevewis = userData.data()!["num_of_reviews"];
          avg = userData.data()!["average_rating"];
          rating = avg.toString();
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: AppGlobals.screenWidth / 1.2,
      height: AppGlobals.screenHeight / 4,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(widget.mainImageURL!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            // to make  clickable image
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new RecipeView(
                            cookbook: "",
                            recipeid: widget.RecipeId,
                            autherId: widget.autherId,
                            isFromMealPlan: false,
                          )));
            }, //what happend after clicking image
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.recipeName!,
                style: TextStyle(
                    fontSize: 19, color: Colors.white), // color of the title
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        rating,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }
}
