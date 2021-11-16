import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/ingredients_text_fields.dart';
import 'package:instayum1/widget/pickers/recipe_image_picker.dart';

//import 'dynamic_fields.dart';
class addRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => addRecipe();
}

class addRecipe extends State<addRecipePage> {
  final _formKey = GlobalKey<FormState>();

//___________________DATABASE_________________
  String _recipeTitle;
  // we put one null value instaed of "List<String>()" to make the lenght of list 1 instaed of 0
  // to meke _getIngredients() method create one empty feild
  // we will add the ingredients to database from this list
  static List<String> userIngredients = [null];

  //List<String> _userIngredients = List<String>();
  List<String> _userDirections = List<String>();

  var currentSelectedTypeOfMeal = "Breakfast";
  var currentSelectedCategory = "Appetizers";
  var currentSelectedCuisine = "American";

  // var currentSelectedCuisine = "Select The cuisine";
  // var currentSelectedCategory = "Select the category";
  // var currentSelectedTypeOfMeal = "Select the type of meal";

  bool isPublic = false;

  void addRecipeButton() {
    _formKey.currentState.save();
    final _isValidForm = _formKey.currentState.validate();
    print("recpie title is: ");
    print(_recipeTitle);

    print(currentSelectedTypeOfMeal);
    print(currentSelectedCategory);
    print(currentSelectedCuisine);

    List<String> userIngredientsCopy = List.from(
        userIngredients); // we make a copy of the list to loop one and remove from one, because we can not loop and remove the same list at the same time

    for (var ing in userIngredients) {
      if (ing == "" || ing == null) {
        userIngredientsCopy.remove(ing);
      }
    }
    print("The ingridaint in addRecipebutton method are :  ");
    print("the length: ");
    print(userIngredientsCopy.length);
    for (var ing in userIngredientsCopy) {
      print(ing);
    }

    if (_isValidForm) {
      print("Everything is good");
    }
  }

//___________________________DATABASE_______________________________

//_______ The two methods below is used to create a dynamic TextFormFeild for Ingredients__________________
  // TextEditingController _nameController;
  List<Widget> _getIngredients() {
    print("The ingridaint are: \n ");
    for (var ing in userIngredients) print(ing);
//The line 29 and 30 will be deleted they are jsut for checking :) # delete

    List<Widget> ingredientsTextFieldsList = [];
    for (int i = 0; i < userIngredients.length; i++) {
      ingredientsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0), // that seprate each text form filed
        child: Row(
          children: [
            Expanded(
                child: IngredientsTextFields(
                    i)), // we call the TextFormField widget
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveButton(i == userIngredients.length - 1, i),
          ],
        ),
      ));
    }
    return ingredientsTextFieldsList;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          userIngredients.insert(index + 1, null);
          // insert(the place of text from field , null mean to initialize the text form filed with empty text )
          // we can put (index + 1) = 0 to change it to let the user add at the top
        } else
          userIngredients.removeAt(index);
        setState(() {}); // to refresh the screen
      },
      child: Container(
        // width: 25,
        // height: 25,
        decoration: BoxDecoration(
          color: (add) ? Color(0xFFeb6d44) : Color(0xFFeb6d44),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  //_________________________________________________________________________________________

//----------------------------------------------------
  //var dropdownValue;

  //-----------------------list componint of dropdown list-----------------
  var recipeType = ['Breakfast', 'Lunch', 'Dinner'];
  // i reoreder them alphabaticly
  var recipeCategories = [
    'Appetizers',
    'Main course',
    'Desserts',
    'Drinks',
    'Salads',
    'Soups',
  ];
  // i reoreder them alphabaticly
  var cuisine = [
    'American',
    'Asian',
    'Brazilian',
    'Egypt',
    'French',
    'Gulf',
    'Indian',
    'Italian',
    'Lebanese',
    'Mexican',
    'Turki',
  ];

  int ingredientCounter = 0; // # delete
  int directionCounter = 0; // # delete

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
                      validator: (value) {
                        if (value.isEmpty || value == "") {
                          return "Please enter the name of the recipe";
                        }
                        return null;
                      },
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
                  margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFeb6d44), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Add Friends',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w700, fontSize: 16),
                        // ),
                        ..._getIngredients(),
                        SizedBox(
                          height: 40,
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
                  // child: Container(
                  //   margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                  //   child: ListView(
                  //     children: [
                  //       TextFormField(
                  //         key: ValueKey("direction${directionCounter++}"),
                  //         validator: (value) {},
                  //         onSaved: (value) {
                  //           _userDirections[directionCounter - 1] = value;
                  //         },
                  //       ),
                  //       TextFormField(
                  //         key: ValueKey("direction${directionCounter++}"),
                  //         validator: (value) {},
                  //         onSaved: (value) {
                  //           _userDirections[directionCounter - 1] = value;
                  //         },
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(top: 10),
                  //         child: Align(
                  //           alignment: Alignment.bottomCenter,
                  //           child: ElevatedButton(
                  //             onPressed: () {},
                  //             child: Text('Add more direction'),
                  //             style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all(
                  //                   Color(0xFFeb6d44)),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                          style: const TextStyle(color: Color(0xFFeb6d44)),
                          //we can remove the the code from line 355 to line 362 just try # delete
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
                              value: isPublic,
                              onChanged: (value) {
                                setState(() {
                                  isPublic = value;
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
                    onPressed: addRecipeButton,
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
