import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instayum1/add_recipe_page.dart';
import 'package:instayum1/discover_page.dart';
import 'package:instayum1/screen/profile_screen.dart';
import 'package:instayum1/shopping_list_page.dart';

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
  var appBarTitel = "Profile";
  int indexOfPages = 4;
  List<Widget> _listOfPagesContent = [
    //---------discover page  0-------------
    discoverPage(),
    //--------- mealPlaner page 1------------
    MealPlans(),
    //----------add recipe page 2------------
    addRecipePage(),
    //----------shopping list page 3---------
    ShoppingListPage(),
    //----------profile page 4---------------
    profile(),
  ];
  void change(int index) {
    //this fun will change  app bar titel depend on sent
    // index and will change current page
    setState(() {
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
          child: _listOfPagesContent[indexOfPages],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFFeb6d44),
          unselectedItemColor: Colors.grey[600],
          currentIndex: indexOfPages,
          onTap:
              change, //it will call fun change and send index of clicked below button
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.saved_search_sharp), label: "Discover"),
            BottomNavigationBarItem(
                icon: Icon(Icons.table_view), label: "Meal Planner"),
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
