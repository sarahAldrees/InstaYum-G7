import 'package:flutter/material.dart';
import 'package:instayum1/widget/bookmark/add_new_cookbook.dart';
import 'add_new_cookbook.dart';
import 'package:instayum1/widget/bookmark/cookbook_item.dart';

class bookmarked_recipes extends StatefulWidget {
//----------------Alert dialog------------------------------

  @override
  State<bookmarked_recipes> createState() => bookmarked_recipesState();
}

class bookmarked_recipesState extends State<bookmarked_recipes> {
  TextEditingController _CookbookTitleTextFieldController =
      TextEditingController();

  showAlertDialogOfAddCookbook(BuildContext context) {
    // set up the buttons
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
        _CookbookTitleTextFieldController.clear();
        Navigator.of(context).pop();
      },
    );
    Widget addButton = RaisedButton(
      child: Text(
        "Add new cookbook",
      ),
      onPressed: () {
        AddNewCookBookState.createNewCookBook(
            _CookbookTitleTextFieldController.text);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).backgroundColor,
      title: Center(
          child: Text(
        "Add cookbook",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      )),
      content: TextField(
        controller: _CookbookTitleTextFieldController,
        decoration: InputDecoration(hintText: "Cookbook title"),
      ),
      // Text(
      //   "Enter the title of the cookbook",
      //   style: TextStyle(color: Color(0xFF444444)),
      // ),
      actions: [
        cancelButton,
        addButton,
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
    return MaterialApp(
      // remove the default default flutter banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // build the button to add a new cookbook
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFeb6d44),
            onPressed: () {
              showAlertDialogOfAddCookbook(context);
              // add new cookbook
            },
            child: Icon(Icons.add),
          ),
          // here the list of grid view
          body: GridView.count(
            crossAxisCount: 2, // 2 items in each row
            padding: EdgeInsets.all(25),
            // map all available cookbooks and list them in Gridviwe.
            children: Cookbooks_List.map((c) => cookbook_item(
                  // Key,
                  c.id,
                  c.cookbookName,
                  c.imageURLCookbook,
                )).toList(),
          )),
    );
    // ]);
  }
}
