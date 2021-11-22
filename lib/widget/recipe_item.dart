import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/recipe_view_screen.dart';

class recipe_Item extends StatelessWidget {
  final String autherName;
  final String autherImage;
  final String autherId;
  final String id;
  final String recipeName;
  final String typeOfMeal;
  final String category;
  final String imageURL;
  final String cuisine;
  final List<String> ingredients;
  final List<String> dirctions;

  const recipe_Item(
    // Key key,
    this.autherName,
    this.autherImage,
    this.autherId,
    this.id,
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
    final String image = imageURL;
// this section will return one item of Grid Items that in bookmarked recipes page.
    return Column(children: [
      //ClipOval(
      Container(
        width: double.infinity,
        // height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),

        child: InkWell(
          // to make  clickable image
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new recipe_view(
                        //key,
                        autherName,
                        autherImage,
                        autherId,
                        id,
                        recipeName,
                        imageURL,
                        typeOfMeal,
                        category,
                        cuisine,
                        ingredients,
                        dirctions)));
          }, //what happend after clicking image

          child: ClipRRect(
            child: Container(
              height: 120,
              child: Image.network(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),

      Container(
          // this is for text
          width: double.infinity,
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              recipeName,
              style: TextStyle(fontSize: 14),
            ),
          )),
    ]);
  }
}
