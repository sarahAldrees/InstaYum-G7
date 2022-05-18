import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/bookmark/cookbook_service.dart';
import 'package:instayum/widget/pickers/cookbook_image_picker.dart';

class AddNewCookBook extends StatefulWidget {
  @override
  AddNewCookBookState createState() => AddNewCookBookState();
}

class AddNewCookBookState extends State<AddNewCookBook> {
// to just create an empty cookbook
  static void createNewCookBook(String cookBookTitle) async {
    await CookbookService.addCookbookToDatabase(
        cookBookIDAndTitle: cookBookTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
