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

//_____________________Will be deleted soon_________________________________________________________
    // DateTime timestamp = DateTime.now();

    // print("Add new cookbook method");
    // print(cookBookTitle);
    // String? cookbookImageUrl = CookbookImagePickerState.uploadedFileURL;
    // if (cookbookImageUrl == null) cookbookImageUrl = 'noImage';

    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // final currentUser = await _auth.currentUser;
    // print(currentUser.uid);
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(currentUser.uid)
    //     .collection(
    //         "cookbooks") // create new collcetion of recipes inside user document to save all of the user's recipes
    //     .doc(cookBookTitle)
    //     .set({
    //   "cookbook_id": cookBookTitle,
    //   // "cookBook_title": cookBookTitle,//we will see later
    //   "cookbook_img_url": cookbookImageUrl,
    //   "timestamp": timestamp,
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
