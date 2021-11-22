import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_item.dart';

import '../data.dart';

class my_recipes extends StatelessWidget {
  String autherName;
  String autherImage;
  my_recipes(this.autherName, this.autherImage);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // 2 items in each row
      crossAxisSpacing: 20,

      padding: EdgeInsets.all(25),
      // map all available cookbooks and list them in Gridviwe.
      children: Recipes_Data.map((e) => recipe_Item(
            key,
            autherName,
            autherImage,
            e.id,
            e.recipeName,
            e.imageURL,
            e.typeOfMeal,
            e.category,
            e.cuisine,
            e.ingredients,
            e.dirctions,
          )).toList(),
    );
  }
}
