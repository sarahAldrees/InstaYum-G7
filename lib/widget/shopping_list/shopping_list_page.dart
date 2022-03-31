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
  List<String> _ShoppingList = [];

  bool outvalue = false; //outvalue is change the state of check list
  var checkedstyle = TextDecoration.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConvertTocheckBox(
        _ShoppingList,
        "",
      ),
    );
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
      if (data["shoppingList"] != null) {
        _ShoppingList.clear();
        _ShoppingList = List.from(data["shoppingList"]);
        print("============== @@@@ ==================");
        print(data["shoppingList"][0]);
      }
      if (mounted) setState(() {});
    });
  }
}
