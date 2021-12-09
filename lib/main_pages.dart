import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instayum1/screen/auth_screen.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';
import 'package:instayum1/discover_page.dart';
import 'package:instayum1/screen/profile.dart';
import 'package:instayum1/shopping_list_page.dart';
import 'package:instayum1/widget/auth/auth_form.dart';
import 'package:instayum1/widget/pickers/recipe_image_picker.dart';
import 'meal_plans.dart';

//*********************************************************************
//********************************************************************
//********************************************************************
// change the name to Appbar
//********************************************************************
//********************************************************************
class MainPages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => appPages();
}

class appPages extends State<MainPages> {
//------------------------------Alert meesage for get out of add recipe page-------------------------------

  showAlertDialogGetOutOfAddRecipePage(
      BuildContext context, int indexOfNewPage) {
    // set up the button
    Widget okButton = RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Yes",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: () {
// we will first clear the form

          addRecipe.recipeTitle = '';
          if (addRecipe.recipeTitleController.value.text.isNotEmpty) {
            //to avoid the null exception
            addRecipe.recipeTitleController.clear();
          }

          addRecipe.userIngredients = [null];
          addRecipe.userDirections = [null];
          RecipeImagePickerState.uploadedFileURL = null;

//then we will move the user to the required page
          indexOfPages = indexOfNewPage;
          if (indexOfNewPage == 0)
            appBarTitel = "Discover Page";
          else if (indexOfNewPage == 3)
            appBarTitel = "Shopping List";
          else if (indexOfNewPage == 2)
            appBarTitel = "Add Recipe";
          else if (indexOfNewPage == 1)
            appBarTitel = "Meal Plan";
          else
            appBarTitel = "Profile";

          setState(() {});
          Navigator.of(context).pop(); // to close the alert dialog
        });

    Widget cancelButton = RaisedButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context)
              .pop(); //just close the alert dialog and stay in the same page
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "Warning",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      content: Text(
        "Are you sure you want to leave Add Recipe page? \nYou will lose all of your data!",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        okButton,
        cancelButton,
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

  //----------------------------------------------------------------------------
// this message appear after added a seccfull recipe, and we put in this class because navigator.push not work
  static showAlertDialogRcipeAdedSuccessfully(BuildContext context) {
    // set up the button
    Widget okButton = RaisedButton(
        child: Text("OK"),
        onPressed: () {
          print("ok is clicked");

          // print("Set state in ok button work");
          //to remove the progress bar
          addRecipe.isloading = false;
          indexOfPages = 4;
          appBarTitel = "Profile";
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPages()),
          );
          print("ok is clicked after navigaotr");
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

//------------------------------------------------------------------------------
  static var appBarTitel = "Profile";
  static int indexOfPages = 4;
  static int indexOfPreviousPage = 4;

  List<Widget> listOfPagesContent = [
    //---------discover page  0-------------
    discoverPage(),
    //--------- mealPlaner page 1------------
    MealPlans(),
    //----------add recipe page 2------------
    AddRecipePage(),
    //----------shopping list page 3---------
    ShoppingListPage(),
    //----------profile page 4---------------
    Profile(),
  ];

  void change(int index) {
    //this fun will change  app bar titel depend on sent
    // index and will change current page
    setState(() {
      indexOfPreviousPage = indexOfPages;

      if (indexOfPreviousPage == 2 && index != 2 && !addRecipe.isNullFields()) {
        showAlertDialogGetOutOfAddRecipePage(context,
            index); // if the user want to leave the addRecipe page (indexOfPreviousPage) and not cliking again on the AddRecipe Page (index)
// we will show him a confirmation message

// if the user not in the add recipe page and want to move to any another page it will do it directly without confirmation message
        if (indexOfPreviousPage != 2) {
          indexOfPages = index;

          if (index == 0)
            appBarTitel = "Discover Page";
          else if (index == 3)
            appBarTitel = "Shopping List";
          else if (index == 2)
            appBarTitel = "Add Recipe";
          else if (index == 1)
            appBarTitel = "Meal Plan";
          else
            appBarTitel = "Profile";
        }
      } else {
        //

        print("*****************************");
        print("movingOutOfAddRecipePage");
        //  if (indexOfPreviousPage != 2 || movingOutOfAddRecipePage) {
        indexOfPages = index;

        if (index == 0)
          appBarTitel = "Discover Page";
        else if (index == 3)
          appBarTitel = "Shopping List";
        else if (index == 2)
          appBarTitel = "Add Recipe";
        else if (index == 1)
          appBarTitel = "Meal Plan";
        else
          appBarTitel = "Profile";
      }
    });
  }

// showAlertDialog() function is used to show a confirmation alert when user click on logout button
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "No",
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = RaisedButton(
      child: Text(
        "Yes",
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
        print('sign out^^^^^^^^^^^^^^^^^^^^^^^^^^');
        print('Before moving the user to the sign up page ***********');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).backgroundColor,
      title: Center(
          child: Text(
        "Logout",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      )),
      content: Text(
        "Are you sure you want to logout of the account? ",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        noButton,
        yesButton,
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app,
                            color: Colors.black), // change the color
                        SizedBox(width: 2),
                        Text("Logout"),
                      ],
                    ),
                  ),
                  value: "logout",
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == "logout") {
                  print("cliked in logout");
                  showAlertDialog(context);
                }
              },
            )
          ],
          leading: Container(
              //color: Colors.white,
              child: Image.asset("assets/images/logo.png")),
          backgroundColor: Color(0xFFeb6d44),
          title: Text(appBarTitel),
        ),
        body: Scrollbar(
          isAlwaysShown: true,
          child: listOfPagesContent[indexOfPages],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFFeb6d44),
          unselectedItemColor: Colors.grey[600],
          currentIndex: indexOfPages,
          onTap:
              change, //it will call change function and send index of clicked below button
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.saved_search_sharp), label: "Discover"),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_view), label: "Meal Plan"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_sharp), label: "Add Recipe"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: "Shopping List"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_sharp), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
