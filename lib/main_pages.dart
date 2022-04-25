import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instayum/widget/auth/auth_screen.dart';
import 'package:instayum/widget/add_recipe/add_recipe_page.dart';
import 'package:instayum/widget/discover/discover_page.dart';
import 'package:instayum/widget/follow_and_notification/notification_page.dart';
import 'package:instayum/widget/meal_plan/add_new_mealplan.dart';
import 'package:instayum/widget/meal_plan/mealplan_service.dart';
import 'package:instayum/widget/shopping_list/shopping_list_page.dart';
import 'package:instayum/widget/pickers/recipe_image_picker.dart';
import 'constant/app_globals.dart';
import 'widget/meal_plan/meal_plans.dart';
import 'widget/profile/profile.dart';

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
  @override
  void initState() {
    super.initState();
  }

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
//*****************************************MEALPLAN***************************************************************** */

  showAlertDialogGetOutOfAddMealplanPage(
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

          // addRecipe.recipeTitle = '';
          AddNewMealPlanState.mealplanTitleTextFieldController.text = "";

          MealPlansService.chosenMealDay = 'SUN';
          MealPlansService.hasMealPlanCollection = false;
          AddNewMealPlanState.sunMealPlan.clear();
          AddNewMealPlanState.monMealPlan.clear();
          AddNewMealPlanState.tueMealPlan.clear();
          AddNewMealPlanState.wedMealPlan.clear();
          AddNewMealPlanState.thuMealPlan.clear();
          AddNewMealPlanState.friMealPlan.clear();
          AddNewMealPlanState.satMealPlan.clear();
          AddNewMealPlanState.mealInformation.clear();

          AddNewMealPlanState.sunMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.monMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.tueMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.wedMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.thuMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.friMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);
          AddNewMealPlanState.satMealPlan
              .addAll(AddNewMealPlanState.initiateMealInformation);

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
        "Are you sure you want to leave add mealplan page? \nYou will lose all of your data!",
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

  Future updatePinConditionToTrue(String mealplanID) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //and make all other mealplans the pin condition is false;

    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("mealPlans")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        firebaseFirestore
            .collection("users")
            .doc(AppGlobals.userId)
            .collection("mealPlans")
            .doc(doc.id)
            .update({"is_pinned": false});
      });
    }).then((value) async {
      Timestamp? timestamp = Timestamp.now();
      AppGlobals.pinedMealPlanID = mealplanID;

      await firebaseFirestore
          .collection("users")
          .doc(AppGlobals.userId)
          .collection("mealPlans")
          .doc(mealplanID)
          .update({"timestamp": timestamp, "is_pinned": true});
    });
  }

  showAlertDialogPinConfirmationMessage(
      BuildContext context, String? mealplanID) {
    // set up the button
    Widget okButton = RaisedButton(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("Yes"),
        onPressed: () {
          // MealPlanCardState.isPinProcessLoading = true;
          indexOfPages = 4;
          appBarTitel = "Profile";
          Navigator.of(context).pop();
          ProfileState.selectedPage = 1;
          ProfileState.isPinnedInPublicMealPlans =
              ProfileState.isPinnedInPublicMealPlans;

          updatePinConditionToTrue(mealplanID!);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPages()),
          );

          // to close the alert dialog
        });

    Widget cancelButton = RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: () {
          Navigator.of(context)
              .pop(); //just close the alert dialog and stay in the same page
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "Pin this Meal plan",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      content: Text(
        "This will appear at the top of your mealsplan and replcase and previously pinned meal plan. Are you sure?",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        cancelButton,
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

  //*****************************************MEALPLAN***************************************************************** */
// this message appear after added a seccfull recipe, and we put in this class because navigator.push not work
  static showAlertDialogRcipeAdedSuccessfully(
      BuildContext context, bool isFromMealPlan) {
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

          if (isFromMealPlan) {
            //to make the tab bar point to my mealplans
            ProfileState.selectedPage = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPages()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPages()),
            );
          }
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
    DiscoverPage(),
    //--------- mealPlaner page 1------------
    AddNewMealPlan("", ""),
    //Text("data"),
    //----------add recipe page 2------------
    AddRecipePage(),
    //----------shopping list page 3---------
    ShoppingListPage(),
    //----------profile page 4---------------
    Profile(),
  ];

  void change(int index) {
    if (index == 1) {
      // 1 = add meal plan
      setState(() {
        isMealClicked = true;
      });
    } else {
      setState(() {
        isMealClicked = false;
      });
    }
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
      } else if (indexOfPreviousPage == 1 &&
          index != 1 &&
          !AddNewMealPlanState.isAddMealplanNullFields()) {
        showAlertDialogGetOutOfAddMealplanPage(context, index);

        if (indexOfPreviousPage != 1) {
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
        print("Nooooooooooooooooooooooooo");
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = RaisedButton(
      child: Text(
        "Yes",
      ),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(AppGlobals.userId)
            .update({"pushToken": ''});
        AppGlobals().resetGlobals();
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

  bool isMealClicked = false;

  @override
  Widget build(BuildContext context) {
    AppGlobals.screenHeight = MediaQuery.of(context).size.height;
    AppGlobals.screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(),
                    ));
              },
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app,
                          color: Colors.black), // change the color
                      SizedBox(width: 2),
                      Text("Logout"),
                    ],
                  ),
                  value: 1,
                ),
              ],
              onSelected: (dynamic val) {
                showAlertDialog(context);
              },
            ),
            // DropdownButton(
            //   icon: Icon(
            //     Icons.more_vert,
            //     color: Theme.of(context).primaryIconTheme.color,
            //   ),
            //   items: [
            //     DropdownMenuItem(
            //       child: Container(
            //         child: Row(
            //           children: <Widget>[
            //             Icon(Icons.exit_to_app,
            //                 color: Colors.black), // change the color
            //             SizedBox(width: 2),
            //             Text("Logout"),
            //           ],
            //         ),
            //       ),
            //       value: "logout",
            //     ),
            //   ],
            //   onChanged: (itemIdentifier) {
            //     if (itemIdentifier == "logout") {
            //       print("cliked in logout");
            //       showAlertDialog(context);
            //     }
            //   },
            // )
          ],
          leading: Container(
              //color: Colors.white,
              child: Image.asset("assets/images/logo.png")),
          backgroundColor: Color(0xFFeb6d44),
          title: Text(appBarTitel),
        ),
        body: listOfPagesContent[indexOfPages],
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
                icon: isMealClicked
                    ? new Image.asset("assets/images/orangeCalendar.png")
                    : new Image.asset(
                        "assets/images/grayCalender.png",
                        height: 24,
                        width: 24,
                      ),
                label: "Meal Plan"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_sharp), label: "Add Recipe"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Shopping List"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_sharp), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
