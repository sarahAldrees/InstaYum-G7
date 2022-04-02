import 'package:flutter/material.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';

class MealTitle extends StatefulWidget {
  String? mealPlanTypeOfMeal;
  final String? title;
  // final String typeOfMeal;
  final String? img;
  String? mealDay;
  bool isFromAddMealplan = false;
  String? recipeID;
  //   نستقبل التايتل و والدسكربشن و الامج حقت الصورة اللي اختارها ونغير نافيقيت تو تصير للريسيبي نفسها

  MealTitle(
      {this.title,
      this.mealPlanTypeOfMeal, //this.typeOfMeal,
      this.img,
      this.mealDay,
      required this.isFromAddMealplan,
      this.recipeID});

  @override
  _MealTitleState createState() => _MealTitleState();
}

class _MealTitleState extends State<MealTitle> {
  @override
  Widget build(BuildContext context) {
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
        // setState(() {
        //   widget.mealDay = AddNewMealPlanState.weekday;
        // });
//in case is from add meal plan
        if (widget.isFromAddMealplan) {
          // Navigator.push(
          //   context,
          // MaterialPageRoute(
          //   builder: (context) => ChooseMealRecipes(
          //       widget.mealDay!, widget.mealPlanTypeOfMeal!),
          // ),
          // );
        } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         RecipeView(isFromMealPlan: false, recipeid: widget.recipeID),
          //   ),
          // );
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
                        image: NetworkImage(widget
                            .img!), //   "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43"),
                        // fit: BoxFit.cover,
                      ),
                    ),

                    //  Image.network(
                    //   // RECIPE IMAGE
                    //   "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43",
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  // Positioned(
                  //   // child: _buildFavoriteButton(),
                  //   top: 2.0,
                  //   right: 2.0,
                  // ),
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

// return Container(
//   margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
//   height: 136,
//   width: 50,
//   decoration: const BoxDecoration(
//     color: Colors.black12,
//     borderRadius: BorderRadius.all(Radius.circular(20)),
//   ),
//   child:
//       //Padding(
//       // padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
//       // child:
//       Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(
//         widget.title,
//         style: const TextStyle(
//             color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
//         textAlign: TextAlign.center,
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       Text(
//         widget.description,
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 15,
//         ),
//         textAlign: TextAlign.center,
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//     ],
//   ),
//   //  ),
// );
