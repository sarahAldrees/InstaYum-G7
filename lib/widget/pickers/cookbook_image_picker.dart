import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class CookbookImagePicker extends StatefulWidget {
  //const CookbookImagePicker({ Key? key }) : super(key: key);

  @override
  CookbookImagePickerState createState() => CookbookImagePickerState();
}

class CookbookImagePickerState extends State<CookbookImagePicker> {
  static bool isUploadCookbookImageIsloading =
      false; // to show the progress circle
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
      isUploadCookbookImageIsloading = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;

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
        // to add https://
        setState(() {
          uploadedFileURL = fileURL;
          print("set state work now!");
        });
      }).then((nothing) async {
        // nothing mean null, but null cause an error
        setState(() {
          isUploadCookbookImageIsloading = false;
        });
      });
    });
  }

  Widget buildCookbookImage() {
    final image = uploadedFileURL == "noImage" ||
            // uploadedFileURL.isEmpty ||
            uploadedFileURL == null
        ? AssetImage("assets/images/defaultCookbookImage.png") // NEW
        : NetworkImage(uploadedFileURL);

    // build a circular user image

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipOval(
        child: Material(
          color: Colors.grey.shade400,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        buildCookbookImage(),
        isUploadCookbookImageIsloading
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFeb6d44),
                  color: Colors.white,
                ),
              )
            : FlatButton.icon(
                onPressed: chooseFile,
                textColor: Theme.of(context).accentColor,
                icon: Icon(Icons.image),
                label: Text("Choose cookbook image")),
      ],
    );
  }
}
