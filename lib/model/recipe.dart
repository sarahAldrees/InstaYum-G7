import 'package:flutter/cupertino.dart';

class Recipe {
  // final Key key; //??
  final String id; //change to user id
  final String recipeName;
  final String imageURL;
  final String category;
  final String typeOfMeal;
  final List<String> ingredients;
  final List<String> dirctions;
  final String cuisine;

  const Recipe({
    // @required this.key,
    @required this.id,
    @required this.recipeName,
    @required this.imageURL,
    @required this.typeOfMeal,
    @required this.category,
    @required this.cuisine,
    @required this.ingredients,
    @required this.dirctions,
  });
}
