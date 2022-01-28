import 'package:flutter/cupertino.dart';

class Recipe {
  // final Key key; //??
  final String autherId;
  final String id; //change to user id
  final String recipeName;
  final String mainImageURL;
  final String category;
  final String typeOfMeal;
  final String cuisine;
  final List<String> ingredients;
  final List<String> dirctions;
  final List<String> imageUrls;

  const Recipe({
    // @required this.key,
    @required this.autherId,
    @required this.id,
    @required this.recipeName,
    @required this.mainImageURL,
    @required this.typeOfMeal,
    @required this.category,
    @required this.cuisine,
    @required this.ingredients,
    @required this.dirctions,
    @required this.imageUrls,
  });
}
