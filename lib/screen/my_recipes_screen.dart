import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_item.dart';

import '../data.dart';

class my_recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // 2 items in each row
      crossAxisSpacing: 20,

      padding: EdgeInsets.all(25),
      // map all available cookbooks and list them in Gridviwe.
      children: Recipes_Data.map((e) => recipe_Item(key, e.id, e.recipeName,
          e.category, e.imageURL, e.ingredients, e.steps, e.duration)).toList(),
    );
  }
}
