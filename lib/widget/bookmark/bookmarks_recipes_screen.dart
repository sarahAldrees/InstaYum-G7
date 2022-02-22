import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/widget/pickers/cookbook_image_picker.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/widget/bookmark/add_new_cookbook.dart';
import 'package:instayum/widget/pickers/cookbook_image_picker.dart';
import 'add_new_cookbook.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:instayum/widget/bookmark/cookbook_item.dart';

class BookmarkedRecipes extends StatefulWidget {
  static bool Saved = false;
  //String autherId;
  String recipeId;

  BookmarkedRecipes(this.recipeId);

//----------------Alert dialog------------------------------

  @override
  State<BookmarkedRecipes> createState() => BookmarkedRecipesState();
}

class BookmarkedRecipesState extends State<BookmarkedRecipes> {
  String? imagePath;
  File? image;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //bool _isEmptyCookbookTitle = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cookbookTitle = "";
  bool validCookbookName = true;
  static String? uploadedFileURL;
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getCookbookObjects());
  }

  static var Cookbooks_List = [
    Cookbook(
      id: 'All bookmarked recipes',
      // cookbookName: 'All bookmarked recipes',
      imageURLCookbook:
          'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
    ),
  ];

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
        CookbookImagePickerState.uploadedFileURL = null;
        Navigator.of(context).pop();
      },
    );
    Widget addButton = RaisedButton(
        child: Text(
          "Add new cookbook",
        ),
        onPressed: () async {
          String cookbookTitle = _CookbookTitleTextFieldController.text;

          if (CookbookImagePickerState.isUploadCookbookImageIsloading) {
            Flushbar(
              backgroundColor: Theme.of(context).errorColor,
              message: "Please wait until the the cookbook's image is loaded",
              duration: Duration(seconds: 4),
            ).show(context);
          } else {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              validCookbookName = await _checkCookbookName(
                  _CookbookTitleTextFieldController.text);
              if (validCookbookName) {
                AddNewCookBookState.createNewCookBook(cookbookTitle);

                getCookbookObjects(); // to refresh the page after adding a new cookbook
                // -------------------Clear the data ---------------------------
                CookbookImagePickerState.uploadedFileURL = null;
                _CookbookTitleTextFieldController.clear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "The $cookbookTitle cookbook has been added successfully"),
                      backgroundColor: Colors.green),
                );
              } else {
                Flushbar(
                  backgroundColor: Theme.of(context).errorColor,
                  message: "The name is already exist",
                  duration: Duration(seconds: 4),
                ).show(context);
              }
            }
          }
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).backgroundColor,
      title: Center(
        child: Text(
          "Add cookbook",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
//--------------------------------------
      content: new SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //the big container
              width: 300,
              height: 180,
              alignment: Alignment.center,
              child: CookbookImagePicker(),
              // recipe_id # delete
            ),
            Form(
              key: formKey,
              child: TextFormField(
                key: ValueKey("cookbook_title"),
                controller: _CookbookTitleTextFieldController,
                decoration: InputDecoration(
                    // errorText:
                    //     _isEmptyCookbookTitle ? 'title can not be empty' : null,
                    hintText: "Cookbook title"),
                validator: (value) {
                  if (value == null || value == '' || value.isEmpty)
                    return 'title can not be empty ';
                  else
                    return null;
                },
                onSaved: (value) {
                  cookbookTitle = value!;
                },
              ),
            )
          ],
        ),
      ),

      actions: [
        Row(
          children: [
            cancelButton,
            SizedBox(
              width: 2,
            ),
            addButton,
          ],
        )
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

  Future<bool> _checkCookbookName(String cookBookname) async {
    User? user = firebaseAuth.currentUser;
    final result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("cookbooks")
        .where('cookbook_id', isEqualTo: cookBookname)
        .get();
    return result.docs.isEmpty;
  }

  void getCookbookObjects() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // final currentUser = await _auth.currentUser;
    final timestamp =
        DateTime.now(); // to update the time and make the default upper
    FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("cookbooks")
        .doc("All bookmarked recipes")
        .update({"timestamp": timestamp});

    Cookbooks_List = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(AppGlobals.userId)
        .collection("cookbooks")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      if (CookbookItem.isBrowse) {
        Cookbooks_List = [];
        querySnapshot.docs.forEach(
          (doc) => {
            // will delete the arraw
            // Map data = doc.data(),
            // Cookbook cookbook = Cookbook.formJson(data  as Map<String, dynamic>),
            // Cookbooks_List.add(cookbook),

            Cookbooks_List.add(
              Cookbook(
                id: doc.data()['cookbook_id'],
                // cookbookName: ,
                imageURLCookbook: doc.data()['cookbook_img_url'],
              ),
            ),
          },
        );
        if (mounted) setState(() {});
      } else {
        Cookbooks_List = [];
        querySnapshot.docs.forEach(
          (doc) => {
            if (doc.data()['cookbook_id'] != "All bookmarked recipes")
              {
                Cookbooks_List.add(
                  Cookbook(
                    id: doc.data()['cookbook_id'],
                    // cookbookName: ,
                    imageURLCookbook: doc.data()['cookbook_img_url'],
                  ),
                ),
              }
          },
        );
        if (mounted) setState(() {});
      }
    });
  }

  GridView showingData() {
    return GridView.count(
      crossAxisCount: 2, // 2 items in each row
      padding: EdgeInsets.all(25),
      // map all available cookbooks and list them in Gridviwe.
      children: Cookbooks_List.map((c) =>
              //if (CookbookItem.isBrowse) {
              CookbookItem(
                // Key,
                c.id,
                c.imageURLCookbook,
                // c.colorOfCircule=Colors.grey.shade300,
              )
          // }
          ).toList(),
    );
  }

  Scaffold checking() {
    if (!CookbookItem.isBrowse) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "The recipe will be in all bookmared recipes and your selected cookbook if any",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 12),
              maxLines: 3,
            ),
          ),

          backgroundColor: Colors.white,
          elevation: 0,
          // shape:
          //     Border(bottom: BorderSide(color: Color(0xFFeb6d44), width: 4)),
          // title: Text("hi"),
          actions: [
            // TextButton(
            //   child: Text(
            //     "Cancel",
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   style: TextButton.styleFrom(
            //     primary: Color(0xFFeb6d44),
            //     backgroundColor: Colors.white,
            //     //side: BorderSide(color: Colors.deepOrange, width: 1),
            //     elevation: 0,
            //     //minimumSize: Size(100, 50),
            //     //shadowColor: Colors.red,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       cookbook_item.isBrowse = true;
            //     });
            //     Navigator.pop(context);
            //   },
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            TextButton(
              child: Text(
                "Save",
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
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                DateTime timestamp = DateTime.now();
                for (int i = 0;
                    i < CookbookItem.selectedCookbooks.length;
                    i++) {
                  List<String> b2 = [];
                  //----------------------------------
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("cookbooks")
                      .doc(CookbookItem.selectedCookbooks[i])
                      .get()
                      .then((document) {
                    b2.clear();
                    if (document != null) {
                      // print('rating data: ${document.data()}');
                      //usersAlredyRate.clear();
                      Map<String, dynamic>? data = document.data();

                      if (data != null) {
                        Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
                        b2 = List.from(bookmarkedRecipe.bookmarkedList!);
                      }
                    }
                  });
                  //--------------------------------------
                  b2.add(widget.recipeId);
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("cookbooks")
                      .doc(CookbookItem.selectedCookbooks[i])
                      .update({"bookmarkedList": FieldValue.arrayUnion(b2)});
                }
                List<String> b2 = [];
                //----------------------------------
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("cookbooks")
                    .doc("All bookmarked recipes")
                    .get()
                    .then((document) {
                  if (document != null) {
                    Map<String, dynamic>? data = document.data();

                    if (data != null) {
                      Cookbook bookmarkedRecipe = Cookbook.fromJson(data);
                      print(bookmarkedRecipe.id);
                      b2 = List.from(bookmarkedRecipe.bookmarkedList!);
                    }
                  }
                });
                //--------------------------------------
                b2.add(widget.recipeId);
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("cookbooks")
                    .doc("All bookmarked recipes")
                    .update({"bookmarkedList": FieldValue.arrayUnion(b2)});
                // FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection("cookbooks")
                //     .doc("All bookmarked recipes")
                //     .collection("bookmarked_recipe")
                //     .doc(widget.recipeId)
                //     .set({
                //   // "autherId": widget.autherId,
                //   "recipeId": widget.recipeId,
                // });

                CookbookItem.isBrowse = true;
                //RecipeViewState.ishappen = false;

                BookmarkedRecipes.Saved = false;
                CookbookItem.selectedCookbooks.clear();
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
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
        body: showingData(),
      );
    } else {
      return Scaffold(
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
        body: showingData(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // remove the default default flutter banner

      body: checking(),
    );
    // ]);
  }
}
