import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/mainpages.dart';
import 'package:instayum1/widget/add_recipe/directions_text_fields.dart';
import 'package:instayum1/widget/add_recipe/ingredients_text_fields.dart';
import 'package:instayum1/widget/pickers/recipe_image_picker.dart';
import 'package:uuid/uuid.dart';

//import 'dynamic_fields.dart';
class addRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => addRecipe();
}

class addRecipe extends State<addRecipePage> {
  //static var formKey = GlobalKey<FormState>();
  // final List<GlobalObjectKey<FormState>> formKey =
  //List.generate(10, (index) => GlobalObjectKey<FormState>(index));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//___________________Attributes_________________

  String _recipeTitle;
  //-----------------------dropdown list for classification-----------------
  var recipeType = ['Breakfast', 'Lunch', 'Dinner'];

  var recipeCategories = [
    'Appetizers',
    'Main course',
    'Desserts',
    'Drinks',
    'Salads',
    'Soups',
  ];

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
  var currentSelectedTypeOfMeal = "Breakfast";
  var currentSelectedCategory = "Appetizers";
  var currentSelectedCuisine = "American";
  bool isPublic = false; //to determin wehther the recipe is public or private

  //-----------------------------------------------------------------------------------

  // we put one null value instaed of "List<String>()" to make the lenght of list 1 instaed of 0
  // to meke _getIngredients() method create one empty feild
  // we will add the ingredients to database from this list
  static List<String> userIngredients = [null];
  static List<String> userDirections = [null];
  var recipe_id = Uuid().v4(); //uuid.v() is a library to create a random key
  // List<String> userIngredientsDatabase = List.from(userIngredients);
  // List<String> userDirectionsDatabase = List.from(userDirections);
  // we make a copy of the list to loop one and remove from one, because we can not loop and remove the same list at the same time
  void addRecipeButton() {
    List<String> userIngredientsCopy = List.from(userIngredients);
    //# delete
    // List<String> userDirectionsCopy = List.from(userDirections);
    // for (var dir in userDirectionsCopy) {
    //   if (dir == "" || dir == null) {
    //     userDirections.remove(dir);
    //   }
    // }

//to remove the last field (both in ingredients and directions)if it was empty and there weremore than one field
    if ((userIngredients[userIngredients.length - 1] == null ||
            userIngredients[userIngredients.length - 1] == "") &&
        userIngredients.length > 1) {
      userIngredients.removeAt(userIngredients.length - 1);
    }
    if ((userDirections[userDirections.length - 1] == null ||
            userDirections[userDirections.length - 1] == "") &&
        userDirections.length > 1) {
      userDirections.removeAt(userDirections.length - 1);
    }

    setState(() {}); //to refresh the page after delete any empty fields

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      addRecipeToDatabase();
    }
  }

  void addRecipeToDatabase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;
//# delete
    // print("Everything is in the database ");
    // print('recipe name before the saving');
    // print(_recipeTitle);
// to save the title , length of ingredients and length of directions
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(currentUser.uid)
    //     .collection(
    //         "recpies") // create new collcetion of recpies inside user document to save all of the user's recpies
    //     .doc(recipe_id)
    //     .set({
    //   "recipe_title": _recipeTitle,
    //   'length_of_ingredients': userIngredients.length,
    //   'length_of_directions': userDirections.length,
    //   'user_id': currentUser.uid,
    // });

    await FirebaseFirestore.instance
        .collection(
            "recpies") // create new collcetion of recpies inside user document to save all of the user's recpies
        .doc(recipe_id)
        .set({
      "recipe_title": _recipeTitle,
      'length_of_ingredients': userIngredients.length,
      'length_of_directions': userDirections.length,
      'user_id': currentUser.uid,
    });
// to save the ingredients
    int countItems = 0;
    for (var ing in userIngredients) {
      countItems++;
      await FirebaseFirestore.instance
          // .collection("users")
          // .doc(currentUser.uid)
          .collection("recpies")
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
          // .collection("users")
          // .doc(currentUser.uid)
          .collection("recpies")
          .doc(recipe_id)
          .update({
        'dir$countItems': dir,
      });
    }
// to save the classification
    String recipe_image_url = RecipeImagePickerState.uploadedFileURL;

    if (recipe_image_url == null) recipe_image_url = 'noImageUrl';

    await FirebaseFirestore.instance
        // .collection("users")
        // .doc(currentUser.uid)
        .collection("recpies")
        .doc(recipe_id)
        .update({
      'type_of_meal': currentSelectedTypeOfMeal,
      'category': currentSelectedCategory,
      'cuisine': currentSelectedCuisine,
      'recipe_image_url': recipe_image_url,
    });
    formKey.currentState.reset();

    showAlertDialogREcipeAdedSuccessfully(context);

//# delete
    // print("The ingridaint in addRecipebutton method are :  ");
    // print("the length: ");
    // print(userIngredientsDatabase.length);
    // for (var ing in userIngredientsDatabase) {
    //   print(ing);
    // }
    // print("The Directions in addRecipebutton method are :  ");
    // print("the length: ");
    // print(userDirectionsDatabase.length);
    // for (var dir in userDirectionsDatabase) {
    //   print(dir);
    // }
    // print('the id in recipe class is  ');
    // print(recipe_id);
    // print("recpie title is: ");
    // print(_recipeTitle);
    // print("url: ");
    // print(RecipeImagePickerState.uploadedFileURL);
    // print(currentSelectedTypeOfMeal);
    // print(currentSelectedCategory);
    // print(currentSelectedCuisine);
  }

  showAlertDialogREcipeAdedSuccessfully(BuildContext context) {
    // set up the button
    Widget okButton = RaisedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPages()),
          );
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Added successfully",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "The add operation was done successfully... ",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//_______ The two methods below is used to create a dynamic TextFormFeild for Ingredients__________________
  TextEditingController _ingredientController;
  List<Widget> _getIngredients() {
    List<Widget> ingredientsTextFieldsList = [];
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
              // i == userIngredients.length - 1 is used to add  "add" button at last Ingredients row only
              _addRemoveButtonInIngredient(i == userIngredients.length - 1,
                  i), //to return the button(wether it wass add or remove )
            ],
          ),
        ),
      );
    }
    return ingredientsTextFieldsList;
  }

  Widget _addRemoveButtonInIngredient(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          userIngredients.insert(index + 1, null);
          // insert(the place of text from field , null mean to initialize the text form filed with empty text )
          // (index + 1) to add the fields below each others
        } else {
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
  List<Widget> _getDirections() {
    List<Widget> DirectionsTextFieldsList = [];
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
              // i == userIngredients.length - 1 is used to add  "add" button at last Ingredients row only
              _addRemoveButtonInDirection(i == userDirections.length - 1, i),
              //to return the button(wether it wass add or remove )
            ],
          ),
        ),
      );
    }
    return DirectionsTextFieldsList;
  }

  Widget _addRemoveButtonInDirection(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          userDirections.insert(index + 1, null);
          // insert(the place of text from field , null mean to initialize the text form filed with empty text )
          // (index + 1) to add the fields below each others
        } else {
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
                child: RecipeImagePicker(recipe_id),
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
                          ..._getDirections(), //the method will return a list of directions
                          //three dots used to seprate the list
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
                            style: const TextStyle(
                              color: Color(0xFF616161),
                            ),
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
                            style: const TextStyle(color: Color(0xFF616161)),
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
                            style: const TextStyle(color: Color(0xFF616161)),
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
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: ElevatedButton(
                    onPressed: addRecipeButton,
                    child: Text('Add recipe'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFeb6d44)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
