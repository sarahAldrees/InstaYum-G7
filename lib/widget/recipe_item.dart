import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeItem extends StatelessWidget {
  // final String autherName;
  // final String autherImage;
  final String autherId;

  final String RecipeId;
  final String recipeName;
  final String typeOfMeal;
  final String category;
  final String imageURL;
  final String cuisine;
  final List<String> ingredients;
  final List<String> dirctions;

  const RecipeItem(
    // Key key,
    // this.autherName,
    // this.autherImage,
    this.autherId,
    this.RecipeId,
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
    final image = imageURL == "noImageUrl" ||
            imageURL.isEmpty ||
            imageURL == null
        ? AssetImage("assets/images/defaultRecipeImage.png")
        : NetworkImage(
            imageURL); // the image will be used in ClipRRect, specifically in  Ink.image under Material widget

// this section will return one item of Grid Items that in bookmarked recipes page. (i do not think it is in bookmarked, it is in "my recipe" :) )
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Column(children: [
        //ClipOval(
        Container(
          width: double.infinity,
          // height: 100,
          decoration: BoxDecoration(
            color: Colors
                .white, // to make the background of the photo white (it is the corners)
          ),

          child: Container(
            height: 110,
            child: InkWell(
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
                            imageURL,
                            typeOfMeal,
                            category,
                            cuisine,
                            ingredients,
                            dirctions)));
              }, //what happend after clicking image

              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                    color: Colors.grey.shade100,
                    child:
                        Ink.image(image: image, height: 120, fit: BoxFit.fill)
                    //************************************8 very importatnt to check which attribute is the best with boxfit ? # delete */

                    ),
              ),
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Container(
                // this is for text
                width: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    recipeName,
                    style: TextStyle(fontSize: 14),
                  ),
                )),
          ),
        ),
      ]),
    );
  }
}
