import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/checkbox_state.dart';
import 'package:instayum/widget/recipe_view/convert_to_check_box.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingListPage> {
  static List<String?> ShoppingList = [];

  bool outvalue = false; //outvalue is change the state of check list
  var checkedstyle = TextDecoration.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: ),
                              // padding: EdgeInsets.only(right: 6),
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                            Text('Add to Shoping List'),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        convert.AddToShoppingList("", context),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                });
          },
          label: Text("Add a new ingrediant"),
          backgroundColor: Color(0xFFeb6d44),
          //Color(0xFFeb6d44),
        ),
        body: !ShoppingList.isEmpty
            ? ConvertTocheckBox(
                ShoppingListState.ShoppingList,
                "",
              )
            : Center(
                child: Text("the shoping List is empty"),
              ));
  }

  @override
  void initState() {
    super.initState();
    getShoppingListIngredients(); // to create a create All Bookmarked Recipes  cookbook for each user when the user create an account
  }

  deleteFromShoppingListIngredients() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .snapshots()
        .listen((data) {
      if (data["shoppingList"] != null) {
        // for(){}
        // // _ShoppingList.clear();
        // // _ShoppingList = List(data["shoppingList"]);
        // // print("============== @@@@ ==================");
        // // print(data["shoppingList"][0]);
      }
    });
  }

  getShoppingListIngredients() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .snapshots()
        .listen((data) {
      if (data.data()!.containsKey("shoppingList")) {
        ShoppingListState.ShoppingList.clear();
        ShoppingListState.ShoppingList = List.from(data["shoppingList"]);
      }
      print("============== @@@@ ==================");
      // print(data["shoppingList"][0]);
      if (mounted) setState(() {});
    });
  }
}
