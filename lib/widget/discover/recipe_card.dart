import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';

class RecipeCard extends StatefulWidget {
  final String autherId;
  final String RecipeId;
  final String recipeName;
  final String typeOfMeal;
  final String category;
  final String mainImageURL;
  final String cuisine;
  final List<String> ingredients;
  final List<String> dirctions;
  final List<String> imageUrls;

  //final String title;
  //final String rating; ///LAAAAATTTTTTTTTTTTTTEEEEEEEEEEEEEEEEERRR
  //final String cookTime;
  //final String thumbnailUrl;
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
    // @required this.title,
    // // @required this.cookTime,
    // @required this.rating,
    // @required this.thumbnailUrl,
  );

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  var numOfRevewis;
  var avg = 0.0;
  var rating;

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.autherId)
        .collection("recipes")
        .doc(widget.RecipeId)
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
    final List<String> ingredients = ["milk"];

    final List<String> dirctions = ["1"];

    final List<String> dircimageUrlst = [
      "  https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43"
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: 325,
      height: 180,
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
          image: NetworkImage(widget.mainImageURL),
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
                          //key,
                          // autherName,
                          // autherImage,
                          widget.autherId,
                          widget.RecipeId,
                          widget.recipeName,
                          widget.mainImageURL,
                          widget.typeOfMeal,
                          widget.category,
                          widget.cuisine,
                          ingredients,
                          dirctions,
                          widget.imageUrls)));
            }, //what happend after clicking image
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.recipeName,
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
                        numOfRevewis.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white), // text size ----------
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   margin: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.black.withOpacity(0.4),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.schedule,
                //         color: Colors.yellow,
                //         size: 18,
                //       ),
                //       SizedBox(width: 7),
                //       Text(
                //         cookTime,
                //         style: TextStyle(fontSize: 14),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }
}
