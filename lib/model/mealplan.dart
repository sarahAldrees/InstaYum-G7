import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// test
class MealPlan {
  String? mealplanTitle;
  String? mealplanID;
  bool? isPinned;
  List<List<String>> sunMealPlan;
  List<List<String>>? monMealPlan;
  List<List<String>>? tueMealPlan;
  List<List<String>>? wedMealPlan;
  List<List<String>>? thuMealPlan;
  List<List<String>>? friMealPlan;
  List<List<String>>? satMealPlan;

  MealPlan(
      {this.mealplanTitle,
      this.mealplanID,
      this.isPinned,
      required this.sunMealPlan,
      required this.monMealPlan,
      required this.tueMealPlan,
      required this.wedMealPlan,
      required this.thuMealPlan,
      required this.friMealPlan,
      required this.satMealPlan});

  // MealPlan.fromJson(Map<String, dynamic> json) {
  //   mealplanTitle = json["mealTitleAndId"];
  //   mealplanID = json["mealDay"];

  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data["mealTitleAndId"] = this.mealplanTitle;
  //   data["mealDay"] = this.mealplanID;

  //   return data;
  // }
}
