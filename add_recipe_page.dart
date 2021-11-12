import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/pickers/recipe_image_picker.dart';

//import 'dynamic_fields.dart';
class addRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => addRecipe();
}

class addRecipe extends State<addRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String _recipeTitle = "";
  List<String> _userIngredients = List<String>();
  List<String> _userDirections = List<String>();

  //var dropdownValue;
  bool isSwitched = false;
  //-----------------------list componint of dropdown list-----------------
  var recipeType = ['Breakfast', 'Lunch', 'Dinner'];
  var cuisine = [
    'Asian',
    'Indian',
    'Gulf',
    'Italian',
    'American',
    'Mexican',
    'French',
    'Brazilian',
    'Turki',
    'Egypt',
    'Lebanese'
  ];
  var recipeCategories = [
    'Main course',
    'Soups',
    'Salads',
    'Desserts',
    'Drinks',
    'Appetizers'
  ];
  var currentSelectedCuisine = 'Asian';
  var currentSelectedCategory = 'Main course';
  var currentSelectedTypeOfMeal = 'Breakfast';
  int ingredientCounter = 0;
  int directionCounter = 0;

  //-----------------------------------
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  //the big container
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.fromLTRB(10, 25, 30, 10),
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFeb6d44), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    child: TextFormField(
                      key: ValueKey("recipe_title"),
                      validator: (value) {},
                      onSaved: (value) {
                        _recipeTitle = value;
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 15,
                  child: Container(
                    //the container of the title text
                    padding: EdgeInsets.only(bottom: 0, left: 10, right: 10),
                    child: Text(
                      "Recipe Title",
                      style: TextStyle(
                        backgroundColor: Colors.grey[50],
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //---------------add photo-------------
            Container(
              //the big container
              width: 50,
              height: 220,
              alignment: Alignment.center,
              //color: Colors.grey,
              child: RecipeImagePicker(),
            ),
            //---------------Ingredients-------------
            Stack(
              children: <Widget>[
                Container(
                  //the biggest border
                  width: double.infinity,
                  height: 200,
                  margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFeb6d44), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    //the container of the text fields only
                    margin: EdgeInsets.only(bottom: 10, left: 50, right: 50),
                    child: ListView(
                      children: [
                        TextFormField(
                          key: ValueKey("ingredient${ingredientCounter++}"),
                          validator: (value) {},
                          onSaved: (value) {
                            _userIngredients[ingredientCounter - 1] = value;
                          },
                        ),
                        TextFormField(
                          key: ValueKey("ingredient${ingredientCounter++}"),
                          validator: (value) {},
                          onSaved: (value) {
                            _userIngredients[ingredientCounter - 1] = value;
                          },
                        ),
                        Container(
                          //the container of the add ingredients button
                          margin: EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Add more ingredient'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFeb6d44)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 5,
                  child: Container(
                    //the container of the ingredients text
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                        backgroundColor: Colors.grey[50],
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //------------------direction-------------------------
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFeb6d44), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    child: ListView(
                      children: [
                        TextFormField(
                          key: ValueKey("direction${directionCounter++}"),
                          validator: (value) {},
                          onSaved: (value) {
                            _userDirections[directionCounter - 1] = value;
                          },
                        ),
                        TextFormField(
                          key: ValueKey("direction${directionCounter++}"),
                          validator: (value) {},
                          onSaved: (value) {
                            _userDirections[directionCounter - 1] = value;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Add more direction'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFeb6d44)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      "Directions",
                      style: TextStyle(
                        backgroundColor: Colors.grey[50],
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //------------------classification ---------------------
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                  padding: EdgeInsets.only(bottom: 10, top: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFeb6d44), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: ListView(
                    children: [
                      //----dropdown--1--------
                      Text(
                        "     Type of meal:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 15, left: 50, right: 50),
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: currentSelectedTypeOfMeal,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[700],
                          ),
                          iconSize: 30,
                          underline: Container(
                            height: 1,
                            color: Colors.grey[700],
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              currentSelectedTypeOfMeal = newValue;
                            });
                          },
                          //????????
                          style: const TextStyle(color: Color(0xFFeb6d44)),
                          selectedItemBuilder: (BuildContext context) {
                            return recipeType.map((String value) {
                              return Text(
                                currentSelectedTypeOfMeal,
                                style: const TextStyle(color: Colors.black),
                              );
                            }).toList();
                          },
                          items: recipeType
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),

                      //----dropdown--2--------
                      SizedBox(
                        height: 10,
                      ),
                      Text("     Category:"),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 15, left: 50, right: 50),
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: currentSelectedCategory,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[700],
                          ),
                          iconSize: 30,
                          underline: Container(
                            height: 1,
                            color: Colors.grey[700],
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              currentSelectedCategory = newValue;
                            });
                          },
                          style: const TextStyle(color: Color(0xFFeb6d44)),
                          selectedItemBuilder: (BuildContext context) {
                            return recipeCategories.map((String value) {
                              return Text(
                                currentSelectedCategory,
                                style: const TextStyle(color: Colors.black),
                              );
                            }).toList();
                          },
                          items: recipeCategories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      //---------------3------------------
                      SizedBox(
                        height: 10,
                      ),
                      Text("     Cuisine:"),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 15, left: 50, right: 50),
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: currentSelectedCuisine,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[700],
                          ),
                          iconSize: 30,
                          underline: Container(
                            height: 1,
                            color: Colors.grey[700],
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              currentSelectedCuisine = newValue;
                            });
                          },
                          style: const TextStyle(color: Color(0xFFeb6d44)),
                          selectedItemBuilder: (BuildContext context) {
                            return cuisine.map((String value) {
                              return Text(
                                currentSelectedCuisine,
                                style: const TextStyle(color: Colors.black),
                              );
                            }).toList();
                          },
                          items: cuisine
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      //--------------------------------------
                      Container(
                        child: Row(
                          children: [
                            Text("      Praivet"),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  //print(isSwitched);
                                });
                              },
                              activeTrackColor: Colors.orange[600],
                              activeColor: Color(0xFFeb6d44),
                            ),
                            Text("Public"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left: 20,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Text(
                        "Classifications",
                        style: TextStyle(
                          backgroundColor: Colors.grey[50],
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    )),
              ],
            ),

            Align(
                alignment: Alignment.bottomCenter,
                //child: Flexible(
                //fit: FlexFit.loose,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add recipe'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFeb6d44)),
                    ),
                  ),
                )
                //),
                ),
          ],
        ),
      ),
    );
  }
}
