import 'package:flutter/material.dart';
import 'package:instayum/model/mealplan.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

import 'add_new_mealplan.dart';
import 'choose_meal_recipes.dart';

class MealTile extends StatefulWidget {
  String? mealPlanTypeOfMeal;
  final String? title;
  // final String typeOfMeal;
  final String? img;
  String? mealDay;
  bool isFromAddMealplan = false;
  String? recipeID;

  MealTile(
      {this.title,
      this.mealPlanTypeOfMeal, //this.typeOfMeal,
      this.img,
      this.mealDay,
      required this.isFromAddMealplan,
      this.recipeID});

  @override
  _MealTileState createState() => _MealTileState();
}

class _MealTileState extends State<MealTile> {
  String image = "";

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!widget.isFromAddMealplan &&
          widget.img ==
              "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95")
        image =
            "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(939).png?alt=media&token=da0640f8-ea4d-4b5a-a370-ef12d368e60b";
      else
        image = widget.img!;
    });

    Padding _buildTitleSection() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // Default value for crossAxisAlignment is CrossAxisAlignment.center.
          // We want to align title and description of recipes left:
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                // RECIPE TITLE when user choose a recipe !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                widget.title!),
            // Empty space:
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(
                  Icons.restaurant_rounded,
                  size: 20.0,
                  color: Colors.grey[600],
                ), // change
                SizedBox(width: 5.0),
                Text(widget.mealPlanTypeOfMeal!
                    // THE TYPE OF RECIPE!!!!!!!!!!!!!!!!!!!!!!!!!1
                    ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.mealDay = AddNewMealPlanState.weekday;
        });
//in case is from add meal plan
        if (widget.isFromAddMealplan) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseMealRecipes(
                  widget.mealDay!, widget.mealPlanTypeOfMeal!),
            ),
          );
        } else {
          if (widget.img ==
              "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/cookbook_image%2FScreenshot%20(828).png?alt=media&token=b9f92769-47cd-4bb2-b88b-9ccbe5626a95") {
            print("the photo is different!!!!!!!!");
          } else
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeView(
                    isFromMealPlan: false, recipeid: widget.recipeID),
              ),
            );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: NetworkImage(image),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}
