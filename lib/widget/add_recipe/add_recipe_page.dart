import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instayum1/widget/add_recipe/directions_text_fields.dart';
import 'package:instayum1/widget/add_recipe/ingredients_text_Fields.dart';
import 'package:instayum1/widget/pickers/recipe_image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../main_pages.dart';

//import 'dynamic_fields.dart';
class AddRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => addRecipe();
}

class addRecipe extends State<AddRecipePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//___________________Attributes_________________

  static String recipeTitle;
  static TextEditingController recipeTitleController = TextEditingController();

  //-----------------------dropdown list for classification-----------------
  final _recipeType = ['Breakfast', 'Lunch', 'Dinner'];

  final _recipeCategories = [
    'Appetizers',
    'Main course',
    'Desserts',
    'Drinks',
    'Salads',
    'Soups',
  ];

  final _cuisine = [
    'American',
    'Asian',
    'Brazilian',
    'Egyptian',
    'French',
    'Gulf',
    'Indian',
    'Italian',
    'Lebanese',
    'Mexican',
    'Turkish',
    'Other'
  ];
  var _currentSelectedTypeOfMeal = "Breakfast";
  var _currentSelectedCategory = "Appetizers";
  var _currentSelectedCuisine = "American";
  bool _isPublic = false; //to determin wehther the recipe is public or private
  static bool isloading = false;

  //-----------------------------------------------------------------------------------

  // we put one null value instaed of "List<String>()" to make the lenght of list 1 instaed of 0
  // to meke _getIngredients() method create one empty feild
  // we will add the ingredients to database from this list
  static List<String> userIngredients = [null];
  static List<String> userDirections = [null];
  var recipe_id = Uuid().v4(); //uuid.v() is a library to create a random key

  //--------------------------------------------------------------------------
  // isNullFields() is used in mainpages.dart to check are the flied null ? if yes we will not show the user the confrimation message of lost data when moving out of add recipe page
  static bool isNullFields() {
    print("####################################################");
    print("#####################################################");
    print("check the data if they are null");
    print(recipeTitle);
    print(userIngredients[0]);
    print(userDirections[0]);
    print(RecipeImagePickerState.uploadedFileURL);

    if ((recipeTitle == null || recipeTitle.isEmpty || recipeTitle == "") &&
        (userIngredients[0] == null ||
            userIngredients[0].isEmpty ||
            userIngredients[0] == "") &&
        (userDirections[0] == null ||
            userDirections[0].isEmpty ||
            userDirections[0] == "") &&
        RecipeImagePickerState.uploadedFileURL == null) {
      return true;
    } else {
      return false;
    }
  }

  //----------------------------------------------------------------------------
  void _addRecipeButton() {
    setState(() {
      //to show the progress bar
      isloading = true;
    });
    List<String> userIngredientsCopy = List.from(userIngredients);

    setState(() {}); //to refresh the page after delete any empty fields

    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      _addRecipeToDatabase();
    } else {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("some fields missing check them please"),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  void _addRecipeToDatabase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;

    DateTime timestamp = DateTime.now();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection(
            "recipes") // create new collcetion of recipes inside user document to save all of the user's recipes
        .doc(recipe_id)
        .set({
      "recipe_title": recipeTitle,
      'length_of_ingredients': userIngredients.length,
      'length_of_directions': userDirections.length,
      'user_id': currentUser.uid,
      "timestamp": timestamp,
    });
// to save the ingredients
    int countItems = 0;
    for (var ing in userIngredients) {
      countItems++;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection("recipes")
          .doc(recipe_id)
          .update({
        'ing$countItems': ing,
      });
    }
// to save the directions
    countItems = 0;
    for (var dir in userDirections) {
      countItems++;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection("recipes")
          .doc(recipe_id)
          .update({
        'dir$countItems': '${countItems}- ' + dir,
      });
    }
// to save the classification
    String recipe_image_url = RecipeImagePickerState.uploadedFileURL;

    if (recipe_image_url == null) recipe_image_url = 'noImageUrl';

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("recipes")
        .doc(recipe_id)
        .update({
      'type_of_meal': _currentSelectedTypeOfMeal,
      'category': _currentSelectedCategory,
      'cuisine': _currentSelectedCuisine,
      'recipe_image_url': recipe_image_url,
      'is_public_recipe': _isPublic,
    });
    //--------------------creat collection of reating with zeros----------
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection(
            "recipes") // create new collcetion of recipes inside user document to save all of the user's recipes
        .doc(recipe_id)
        .collection("rating")
        .doc("recipeRating")
        .set({
      "sum_of_all_rating": 0,
      "num_of_reviews": 0,
      "average_rating": 0.0,
      "user_already_review": FieldValue.arrayUnion([]),
    });

    //-----------------Clear the form--------------------------------
    formKey.currentState.reset();
    recipeTitleController.clear(); //to clean on the screen only
    recipeTitle = ''; // to realy clean it
    userIngredients = [null];
    userDirections = [null];
    RecipeImagePickerState.uploadedFileURL = null;

//--------------------------------------------------------------------
    //to clean the fields ingredients and directions

    setState(() {
      isloading = false;
    });
    // we put it in mainpages because navigitor,push not work
    appPages.showAlertDialogRcipeAdedSuccessfully(context);
  }

//_______ The two methods below is used to create a dynamic TextFormFeild for Ingredients__________________
  TextEditingController _ingredientController;
  List<Widget> ingredientsTextFieldsList = [];
  List<Widget> _getIngredients() {
    ingredientsTextFieldsList = [];
    for (int i = 0; i < userIngredients.length; i++) {
      ingredientsTextFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0), // that seprate each textFormField
          child: Row(
            //to combine the textFormField with button(wether it wass add or remove )
            children: [
              Expanded(
                child: IngredientsTextFields(i),
              ), // we call the TextFormField widget from the ingredients_text_fields class
              SizedBox(
                width: 16,
              ),
              //always false to add a delete button next to each TextFormField, and we will make it true after _getIngredients() in the design section
              _addRemoveButtonInIngredient(false, i),
            ],
          ),
        ),
      );
    }
    return ingredientsTextFieldsList;
  }

  Widget _addRemoveButtonInIngredient(bool add, int index) {
    if (add) {
      userIngredients.insert(index, null); // add a new textFormField
      setState(() {}); // to refresh the page
    }
    return InkWell(
      onTap: () {
        // userIngredients.length > 1 to prevent deleting the field if there is only one field
        if (!add && userIngredients.length > 1) {
          userIngredients.removeAt(index);
        }
        setState(() {}); // to refresh the screen
      },
      child: Container(
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

//_______ The two methods below is used to create a dynamic TextFormFeild for directions__________________
  TextEditingController _directionController;
  List<Widget> DirectionsTextFieldsList = [];
  List<Widget> _getDirections() {
    DirectionsTextFieldsList = [];
    for (int i = 0; i < userDirections.length; i++) {
      DirectionsTextFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0), // that seprate each text form filed
          child: Row(
            children: [
              Expanded(
                child: DirectionsTextFields(i),
              ), // we call the TextFormField widget from the directions_text_fields class
              SizedBox(
                width: 16,
              ),
              _addRemoveButtonInDirection(false,
                  i), //always false to add a delete button next to each TextFormField, and we will make it true after _getDirections() in the design section
            ],
          ),
        ),
      );
    }
    return DirectionsTextFieldsList;
  }

  Widget _addRemoveButtonInDirection(bool add, int index) {
    //  print("Entered addRemoveButtonInDirection");
    if (add) {
      //  print("enterd add ");
      //print("indes in add is ");
      //  print(index);
      userDirections.insert(index, null); // add a new textFormField
      setState(() {}); // to refresh the page
    }
    return InkWell(
      onTap: () {
        // userDirections.length > 1 to prevent deleting the field if there is only one field
        if (!add && userDirections.length > 1) {
          userDirections.removeAt(index);
        }
        setState(() {}); // to refresh the screen
      },
      child: Container(
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

//______________________________________________________________________________

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //---------------add photo-------------
              Container(
                //the big container
                width: 300,
                height: 270,
                alignment: Alignment.center,
                child: RecipeImagePicker(), // recipe_id # delete
              ),
              //----------------------title-------------------------
              Stack(
                children: [
                  Container(
                    //the big container (orange one)
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
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0)),
                        controller: recipeTitleController,
                        key: ValueKey("recipe_title"),
                        validator: (value) {
                          if (value.isEmpty || value == "") {
                            return "Please enter the name of the recipe";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          recipeTitle = value;
                        },
                        onSaved: (value) {
                          recipeTitle = value;
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
              //---------------Ingredients-------------
              Stack(
                children: <Widget>[
                  Container(
                    //the biggest border
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                    padding: EdgeInsets.only(bottom: 0, top: 15),
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
                          ..._getIngredients(), //the method will return a list of ingredints
                          //three dots used to seprate the list

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              constraints: BoxConstraints.tightFor(width: 171),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _addRemoveButtonInIngredient(
                                      true, userIngredients.length);
                                },
                                icon: Icon(Icons.add),
                                label: Text("Add an ingredient"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFeb6d44)),
                                ),
                              ),
                            ),
                          ),
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
                      // to add a width for the button
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
                    margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
                    padding: EdgeInsets.only(bottom: 0, top: 15),
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
                          ..._getDirections(),
                          //the method will return a list of directions
                          //three dots used to seprate the list
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              constraints: BoxConstraints.tightFor(
                                  width: 171), // to add a width for the button
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _addRemoveButtonInDirection(
                                      true, userDirections.length);
                                },
                                icon: Icon(Icons.add),
                                label: Text(" Add a direction "),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFeb6d44)),
                                ),
                              ),
                            ),
                          ),
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
                            value: _currentSelectedTypeOfMeal,
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
                                _currentSelectedTypeOfMeal = newValue;
                              });
                            },
                            style: const TextStyle(
                              color: Color(0xFF616161),
                            ),
                            items: _recipeType
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
                        Text(
                          "     Category:",
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
                            value: _currentSelectedCategory,
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
                                _currentSelectedCategory = newValue;
                              });
                            },
                            style: const TextStyle(color: Color(0xFF616161)),
                            items: _recipeCategories
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
                        Text(
                          "     Cuisine:",
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
                            value: _currentSelectedCuisine,
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
                                _currentSelectedCuisine = newValue;
                              });
                            },
                            style: const TextStyle(color: Color(0xFF616161)),
                            items: _cuisine
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
                              Text("      Private"),
                              Switch(
                                value: _isPublic,
                                onChanged: (value) {
                                  setState(() {
                                    _isPublic = value;
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
                    ),
                  ),
                ],
              ),

              isloading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFFeb6d44),
                        color: Colors.white,
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          child: ElevatedButton(
                            onPressed: _addRecipeButton,
                            child: Text('Add recipe'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFeb6d44)),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
