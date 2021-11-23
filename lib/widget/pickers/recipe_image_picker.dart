import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class RecipeImagePicker extends StatefulWidget {
  //final recipe_id; # delete
  // RecipeImagePicker(this.recipe_id);

  @override
  RecipeImagePickerState createState() => RecipeImagePickerState();
}

class RecipeImagePickerState extends State<RecipeImagePicker> {
  // bool _isFirestPhoto = true; // # delete
  bool _isloading = false; // to show the progress circle
  File _image;
  static String uploadedFileURL;

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
      if (image != null) {
        uploadFile();
      }
    });
  }

  Future uploadFile() async {
    setState(() {
      _isloading = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // final currentUser = await _auth.currentUser; // # delete

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child('recpie_image/${Path.basename(_image.path)}}');

    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      print('File Uploaded');
      res.ref.getDownloadURL().then((fileURL) {
        uploadedFileURL = fileURL;
        print('here in image class ');
        print(fileURL);
        print('the id in image class is  ');
        // print(widget.recipe_id);
        // to add https://
        setState(() {
          uploadedFileURL = fileURL;
          print("set state work now!");
        });
      }).then((nothing) async {
        // nothing mean null, but null cause an error
        setState(() {
          _isloading = false;
        });
        // //to save the image in the database (in recpies collction inside users collectino)
        // if (_isFirestPhoto) {
        //   _isFirestPhoto = false;
        //   // _isFirestPhoto will be false, to prevent the database from creating a new document if the user change the picture
        //   await FirebaseFirestore.instance
        //       .collection("users")
        //       .doc(currentUser.uid)
        //       .collection("recpies")
        //       .doc(widget
        //           .recipe_id) //we bring the same recpie id from the add_recipe_page
        //       .set({
        //     "recipe_image_url": uploadedFileURL,
        //   });
        //   setState(() {
        //     _isloading = false;
        //   });
        // } else {
        //   FirebaseFirestore.instance
        //       .collection("users")
        //       .doc(currentUser.uid)
        //       .collection("recpies")
        //       .doc(widget
        //           .recipe_id) //we bring the same recpie id from the add_recipe_page
        //       .update({
        //     "recipe_image_url": uploadedFileURL,
        //   });
        //   setState(() {
        //     _isloading = false;
        //   });
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 15)),
            uploadedFileURL != null
                ? Image.network(
                    uploadedFileURL,
                    height: 180,
                    width: 180,
                  )
                : Image.asset(
                    "assets/images/defaultRecipeImage.png",
                    height: 200,
                    width: 300,
                  ),
            _isloading
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFFeb6d44),
                      color: Colors.white,
                    ),
                  )
                : TextButton.icon(
                    onPressed: chooseFile,
                    icon: Icon(Icons.image, size: 28),
                    label: Text(
                      "add recipe photo",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFFeb6d44)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
