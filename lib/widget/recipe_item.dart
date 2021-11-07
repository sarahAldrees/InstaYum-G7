import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class recipe_Item extends StatelessWidget {
  final String id;
  final String recipeName;
  final String category;
  final String imageURL;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  const recipe_Item(Key key, this.id, this.recipeName, this.category,
      this.imageURL, this.ingredients, this.steps, this.duration);

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
          onTap: () {}, //what happend after clicking image

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
