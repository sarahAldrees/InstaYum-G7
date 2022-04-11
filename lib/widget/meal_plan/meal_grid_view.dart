import 'package:flutter/material.dart';
import 'meal_tile.dart';

class MealGridView extends StatefulWidget {
  List<List<String>> mealList;

  MealGridView({required this.mealList});

  @override
  _MealGridViewState createState() => _MealGridViewState();
}

class _MealGridViewState extends State<MealGridView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.mealList.length,
      itemBuilder: (BuildContext context, int index) {
        // print("in gride view class^^^^^^^^^^^^^^^^^^^^^^^^^^^");
        // print(widget.mealList[index][0]);
        // print(widget.mealList[index][1]);
        // print(widget.mealList[index][2]);
        return MealTile(
            title: widget.mealList[index][0],
            mealPlanTypeOfMeal: widget.mealList[index][1],
            isFromAddMealplan: false,
            img: widget.mealList[index][2]);
      },
    );
  }
}
