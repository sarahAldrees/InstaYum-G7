import 'package:flutter/cupertino.dart';

class Recipe {
  final String id;
  final String recipeName;
  final String category;
  final String imageURL;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;

  const Recipe({
    @required this.id,
    @required this.recipeName,
    @required this.category,
    @required this.imageURL,
    @required this.ingredients,
    @required this.steps,
    @required this.duration,
  });
}
