import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';

class RecipeCard extends StatelessWidget {
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
          image: NetworkImage(mainImageURL),
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
                          autherId,
                          RecipeId,
                          recipeName,
                          mainImageURL,
                          typeOfMeal,
                          category,
                          cuisine,
                          ingredients,
                          dirctions,
                          imageUrls)));
            }, //what happend after clicking image
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                recipeName,
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
                      // Text(
                      //  rating,
                      // style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.white), // text size ----------
                      //  ),
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
