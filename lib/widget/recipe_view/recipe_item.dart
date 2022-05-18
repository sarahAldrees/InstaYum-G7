import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';
import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String? cookbookitme;
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
  bool isFromMealPlan = false;
  String mealDay;
  String mealPlanTypeOfMeal;
  RecipeItem(
      this.cookbookitme,
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
      this.isFromMealPlan,
      this.mealDay,
      this.mealPlanTypeOfMeal);

  @override
  Widget build(BuildContext context) {
    // to return the default image if user does not enter an image by puting "noImageUrl" in the database and converting here to an image
    final image = mainImageURL == "noImageUrl" ||
            mainImageURL!.isEmpty ||
            mainImageURL == null
        ? AssetImage("assets/images/defaultRecipeImage.png")
        : NetworkImage(
            mainImageURL!); // the image will be used in ClipRRect, specifically in  Ink.image under Material widget

// this section will return one item of Grid Items that in bookmarked recipes page. (i do not think it is in bookmarked, it is in "my recipe" :) )
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Column(children: [
        Container(
          width: double.infinity,
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
                        builder: (context) => RecipeView(
                              cookbook: cookbookitme,
                              autherId: autherId,
                              recipeid: RecipeId,
                              isFromMealPlan: isFromMealPlan,
                              mealDay: mealDay,
                              mealPlanTypeOfMeal: mealPlanTypeOfMeal,
                            )));
              },

              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                    color: Colors.grey.shade100,
                    child: Ink.image(
                        image: image as ImageProvider<Object>,
                        height: 120,
                        fit: BoxFit.cover)),
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
                    recipeName!,
                    style: TextStyle(fontSize: 16),
                  ),
                )),
          ),
        ),
      ]),
    );
  }
}
