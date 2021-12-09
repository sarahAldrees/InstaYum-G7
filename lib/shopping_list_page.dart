import 'package:flutter/material.dart';
import 'package:instayum1/model/CheckBoxState.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingListPage> {
  bool outvalue = false; //outvalue is change the state of check list
  var checkedstyle = TextDecoration.none;
  var listOfIngrediant = [
    CheckBoxState(title: "Milk"),
    CheckBoxState(title: "Eggs"),
    CheckBoxState(title: "Cream"),
    CheckBoxState(title: "Sugar"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.all(12), children: [
        ...listOfIngrediant.map(creatCheckbox).toList(),
      ]),
    );
  }

  Widget creatCheckbox(CheckBoxState checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Color(0xFFeb6d44),
      value: checkbox.outvalue,
      title: Text(checkbox.title,
          style: TextStyle(
            decoration: checkbox.checkedstyle,
            decorationColor: Color(0xFFeb6d44),
            decorationThickness: 4,
          )),
      onChanged: (value) {
        setState(() {
          checkbox.outvalue = value;
          if (checkbox.outvalue == true) {
            checkbox.checkedstyle = TextDecoration.lineThrough;
          } else {
            checkbox.checkedstyle = TextDecoration.none;
          }
        });
      });
}
