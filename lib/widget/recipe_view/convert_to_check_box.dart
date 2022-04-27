import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main.dart';
import 'package:instayum/model/checkbox_state.dart';
import 'package:instayum/widget/shopping_list/shopping_list_page.dart';

//import 'checkboxState.dart';

class ConvertTocheckBox extends StatefulWidget {
  List<String?> listOfin;
  String title;
  bool needConvert = true;
  List<CheckBoxState> listOfIngrediant = [];
  ConvertTocheckBox(this.listOfin, this.title);

  @override
  State<StatefulWidget> createState() => convert();
}

bool outvalue = false; //outvalue is change the state of check list
var checkedstyle = TextDecoration.none;

class convert extends State<ConvertTocheckBox> {
  @override
  Widget build(BuildContext context) {
    //-----------------to conviert String list to checkbox state---------------
    for (int i = 0; i < widget.listOfin.length; i++) {
      if (widget.needConvert)
        widget.listOfIngrediant.add(CheckBoxState(title: widget.listOfin[i]));
      else
        break;
    }
    //--------------------------------------------
    widget.needConvert = false;
    return Column(
      children: [
        widget.title != ""
            ? Container(
                padding:
                    EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
                width: 380,
                decoration: BoxDecoration(
                  color: Color(0xFFeb6d44),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    //backgroundColor: Colors.grey[50],
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Color(0xFFeb6d44),
                    ),
                    TextButton(
                      onPressed: () {
                        //-----------------------------------------------

                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              title: Column(
                                children: [
                                  Text(
                                    'Are you sure to delete all ingrediants ?',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              actions: [
                                Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            right: 30,
                                            left: 30,
                                            bottom: 0),
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30),
                                                    child: Row(
                                                      children: [
                                                        Center(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Icon(Icons
                                                              .delete_outline_rounded),
                                                        )),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Clear",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color(0xFFeb6d44)),
                                                ),
                                                onPressed: () {
                                                  //-------------delete all ingrediant in shoping list -----
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(AppGlobals.userId)
                                                      .update({
                                                    "shoppingList":
                                                        FieldValue.delete(),
                                                  });
                                                  setState(() {
                                                    ShoppingListState
                                                        .ShoppingList.clear();
                                                  });

                                                  //--------------------

                                                  Navigator.pop(context);
                                                }),
                                            TextButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Color(0xFFeb6d44),
                                                backgroundColor: Colors.white,
                                                //side: BorderSide(color: Colors.deepOrange, width: 1),
                                                elevation: 0,
                                                //minimumSize: Size(100, 50),
                                                //shadowColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )))
                              ],
                            );
                          },
                        );
                        //-------------------------------------------
                        // setState(() {

                        //  });
//-------------- to remove ingrediant from shoping list-----------------------------
                        //print(AppGlobals.shoppingList[0]);
                      },
                      child: Text(
                        "Clear the Shopping List ",
                        style: TextStyle(
                          color: Color(0xFFeb6d44),
                          fontSize: 16,
                        ),
                      ),
                      //show dailog
                      //remove all
                    ),
                  ],
                ),
              ),

        //-------------------to creat checkbox from checkbox state list-------------
        ...widget.listOfIngrediant.map(creatCheckbox).toList(),
      ],
    );
  }

//---------------------to creat checkbox list---------------
  Widget creatCheckbox(CheckBoxState checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Color(0xFFeb6d44),
      value: checkbox.outvalue,
      title: widget.title == "Dirctions"
          ? Text(checkbox.title!,
              style: TextStyle(
                decoration: checkbox.checkedstyle,
                decorationColor: Color(0xFFeb6d44),
                decorationThickness: 4,
              ))
          : widget.title == "Ingrediants"
              ? Row(
                  children: [
                    Expanded(
                      child: Text(checkbox.title!,
                          style: TextStyle(
                            decoration: checkbox.checkedstyle,
                            decorationColor: Color(0xFFeb6d44),
                            decorationThickness: 4,
                          )),
                    ),
                    Spacer(),
                    IconButton(
                        padding: EdgeInsets.only(right: 20),
                        icon: Icon(Icons.add_shopping_cart_outlined),
                        onPressed: () {
                          //checkbox.title

                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      Text('Add to the Shopping List'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      AddToShoppingList(
                                          checkbox.title!, context),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  ],
                )
              : Row(
                  children: [
                    Text(checkbox.title!,
                        style: TextStyle(
                          decoration: checkbox.checkedstyle,
                          decorationColor: Color(0xFFeb6d44),
                          decorationThickness: 4,
                        )),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
//-------------- to remove ingrediant from shoping list-----------------------------
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                title: Column(
                                  children: [
                                    Text(
                                      'Are you sure to delete this ingredient?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              right: 30,
                                              left: 30,
                                              bottom: 0),
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30),
                                                      child: Row(
                                                        children: [
                                                          Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Icon(Icons
                                                                .delete_outline_rounded),
                                                          )),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "delete",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                0xFFeb6d44)),
                                                  ),
                                                  onPressed: () {
                                                    //-------------delete all ingrediant in shoping list -----
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(AppGlobals.userId)
                                                        .update({
                                                      "shoppingList": FieldValue
                                                          .arrayRemove(
                                                              [checkbox.title])
                                                    });
                                                    setState(() {
                                                      ShoppingListState
                                                              .ShoppingList
                                                          .remove(
                                                              checkbox.title);
                                                    });

                                                    //--------------------

                                                    Navigator.pop(context);
                                                  }),
                                              TextButton(
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                style: TextButton.styleFrom(
                                                  primary: Color(0xFFeb6d44),
                                                  backgroundColor: Colors.white,
                                                  //side: BorderSide(color: Colors.deepOrange, width: 1),
                                                  elevation: 0,
                                                  //minimumSize: Size(100, 50),
                                                  //shadowColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          )))
                                ],
                              );
                            },
                          );

                          ///-------ssskkss---------
                        }),
                  ],
                ),
      onChanged: (value) {
        setState(() {
          checkbox.outvalue = value!;
          if (checkbox.outvalue == true) {
            checkbox.checkedstyle = TextDecoration.lineThrough;
          } else {
            checkbox.checkedstyle = TextDecoration.none;
          }
        });
      });

  static Widget AddToShoppingList(String? ingredant, BuildContext context) {
    TextEditingController? textController;

    textController = TextEditingController(text: ingredant);

    return Column(
      children: [
        TextFormField(
          controller: textController,
          onChanged: (value) {
            ingredant = textController!.text;
          },
        ),
//--------------------------add or cancel
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: Theme.of(context).accentColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 5,
            ),
            RaisedButton(
                child: Text(
                  "Add ingredient",
                ),
                onPressed: () {
                  // check if the ingredient is already exist do not add it to the shooping
                  if (ShoppingListState.ShoppingList.contains(
                          ingredant!.toUpperCase()) ||
                      ingredant == null ||
                      ingredant == "") {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "The field is empty or ingredient is already exist"),
                          backgroundColor: Theme.of(context).errorColor),
                    );
                    print(ingredant);
                  } else {
                    // -------- Add the ingredant to the shoping list------------
                    ShoppingListState.ShoppingList.add(
                        ingredant!.toUpperCase());

                    // ------ Update the shopping list in the firestore of the user ---------------
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(AppGlobals.userId)
                        .update({
                      "shoppingList":
                          FieldValue.arrayUnion(ShoppingListState.ShoppingList)
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Added successfuly"),
                          backgroundColor: Colors.green),
                    );
                  }
                }),
            // ]);
          ],
        )
      ],
    );
  }
}
