import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class RecipeImagePicker extends StatefulWidget {
  @override
  _RecipeImagePickerState createState() => _RecipeImagePickerState();
}

class _RecipeImagePickerState extends State<RecipeImagePicker> {
  bool _isFirestPhoto = true;
  bool _isloading = false;
  File _image;
  String _uploadedFileURL;
  var recipe_id = "";

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    uploadFile();
  }

//  Future uploadFile() async {
//    final ref = FirebaseStorage.instance.ref().child('chats/${Path.basename(_image.path)}}');
//    UploadTask uploadTask = storageReference.putFile(_image);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    storageReference.getDownloadURL().then((fileURL) {
//      setState(() {
//        _uploadedFileURL = fileURL;
//      });
//    });
//  }

  Future uploadFile() async {
    setState(() {
      _isloading = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser;

    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference
        .ref()
        .child('recpie_image/${Path.basename(_image.path)}}');
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      print('File Uploaded');
      res.ref.getDownloadURL().then((fileURL) {
        // to add https://
        setState(() {
          _uploadedFileURL = fileURL;
          // print("set state work now!");
        });
      }).then((nothing) async {
        //nothing is mean null, but null cause an error

        // to save the image in the database (in recpies collction inside users collectino)
        if (_isFirestPhoto) {
          _isFirestPhoto = false;
          var uuid = Uuid();
          recipe_id = uuid.v4();
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .collection(
                  "recpies") // create new collcetion of recpies inside user document to save all of the user's recpies
              .doc(recipe_id) //uuid.v() is a library to create a random key
              .set({
            "recipe_image_url":
                _uploadedFileURL, // in the near future we will save all the recipe informaion here
          });
          setState(() {
            _isloading = false;
          });
        } else {
          FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .collection(
                  "recpies") // create new collcetion of recpies inside user document to save all of the user's recpies
              .doc(recipe_id) //uuid.v() is a library to create a random key
              .update({
            "recipe_image_url":
                _uploadedFileURL, // in the near future we will save all the recipe informaion here
          });
          setState(() {
            _isloading = false;
          });
        }
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
            // RaisedButton(
            //   child: Text('Choose File'),
            //   onPressed: chooseFile,
            //   color: Colors.cyan,
            // )
            // ,
            _uploadedFileURL != null
                ? Image.network(
                    _uploadedFileURL,
                    height: 150,
                  )
                : Image.asset(
                    "assets/images/defaultUser.png",
                    height: 150,
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
                    icon: Icon(Icons.image, size: 30),
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

// FirebaseStorage storage = FirebaseStorage.instance;

// // Select and image from the gallery or take a picture with the camera
// // Then upload to Firebase Storage
// Future<void> _upload() async {
//   final picker = ImagePicker();
//   PickedFile pickedImage;

//   try {
//     pickedImage = await picker.getImage(
//         source: ImageSource.gallery,

//         // inputSource == 'camera'
//         //     ? ImageSource.camera
//         //     : ImageSource.gallery,
//         maxWidth: 1920);

//     final String fileName = path.basename(pickedImage.path);
//     File imageFile = File(pickedImage.path);

//     try {
//       // Uploading the selected image with some custom meta data
//       await storage.ref(fileName).putFile(
//           imageFile,
//           SettableMetadata(customMetadata: {
//             'recipe_id': '123',
//             'description': 'Some description...'
//           }));

//       // Refresh the UI
//       setState(() {});
//     } on FirebaseException catch (error) {
//       print(error);
//     }
//   } catch (err) {
//     print(err);
//   }
// }

// // Retriew the uploaded images
// // This function is called when the app launches for the first time or when an image is uploaded or deleted
// Future<List<Map<String, dynamic>>> _loadImages() async {
//   List<Map<String, dynamic>> files = [];

//   final ListResult result = await storage.ref().list();
//   final List<Reference> allFiles = result.items;

//   await Future.forEach<Reference>(allFiles, (file) async {
//     final String fileUrl = await file.getDownloadURL();
//     final FullMetadata fileMeta = await file.getMetadata();
//     files.add({
//       "url": fileUrl,
//       "path": file.fullPath,
//       "recipe_id": fileMeta.customMetadata['recipe_id'] ?? 'Nobody',
//       "description":
//           fileMeta.customMetadata['description'] ?? 'No description'
//     });
//   });

//   return files;
// }

// // bool isDefaultImage = false; // should be shanged;
// // File image;

// // var url = ""; // NEW
// // List<Map<String, dynamic>> files = [];
// // if (isDefaultImage) {
// //   url =
// //       "noImage"; // to put the url part in the database with "noImage" if user does not choose an image
// // } else {
// //   // to put the url part in database with user's image url
// //   // NEW
// //   var counter = 0;
// //   final ref = FirebaseStorage.instance.ref();

// //   // .child("recipe_image").child(
// //   //     authResult.user.uid +
// //   //         "jpg"); //we put the user is + jpg to be the name of the image and to make it unqie we use user id

// //   // we add onComplete to can add await
// //   // await ref.putFile(image);

// //   url = await ref.getDownloadURL();
// //   final FullMetadata fileMeta = await ref.getMetadata();
// //   files.add({
// //     'url': url,
// //     'path': ref.fullPath,
// //     "recipe_id": fileMeta.customMetadata['uploaded_by'] ?? 'Nobody',
// //     "description":
// //         fileMeta.customMetadata['description'] ?? 'No description',
// //   });
// //   return files;
// // }

// @override
// Widget build(BuildContext context) {
//   return Column(
//     children: [
//       ElevatedButton.icon(
//         onPressed: () => _upload(),
//         icon: Icon(Icons.library_add),
//         label: Text('Add recipe photo'),
//       ),
//       Expanded(
//         child: FutureBuilder(
//           future: _loadImages(),
//           builder:
//               (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return ListView.builder(
//                 itemCount: snapshot.data?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final Map<String, dynamic> image = snapshot.data[index];

//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       dense: false,
//                       leading: Image.network(image['url']),
//                       title: Text(image['uploaded_by']),
//                       subtitle: Text(image['description']),
//                     ),
//                   );
//                 },
//               );
//             }

//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }
//}
// File _pickedImage;
// void _pickImage() async {
//   final pickedImageFile = await ImagePicker.pickImage(
//     source: ImageSource.gallery,
//     maxWidth: 150,
//   ); //we can add imageQuality: 50 to reduce the qulaity if image to half so the size if it will reduce
//   setState(() {
//     _pickedImage = pickedImageFile;
//   });
//   widget.imagePickFn(pickedImageFile);
// }

// @override
// Widget build(BuildContext context) {
//   return Column(
//     children: [
//       // _pickedImage != null ? Image.file(_pickedImage) : null,
//       TextButton.icon(
//         onPressed: _pickImage,
//         icon: Icon(Icons.add_a_photo, size: 30),
//         label: Text(
//           "add recipe photo",
//           style: TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700]),
//         ),
//         style: ButtonStyle(
//           foregroundColor: MaterialStateProperty.all(Color(0xFFeb6d44)),
//         ),
//       ),
//     ],
//   );

// Column(
//     children: [
//       SizedBox(
//         height: 16,
//       ),
//       CircleAvatar(
//         radius: 37,
//         backgroundColor: Theme.of(context).accentColor,
//         backgroundImage:
//             _pickedImage != null ? FileImage(_pickedImage) : null,
//       ),
//       FlatButton.icon(
//           onPressed: _pickImage,
//           textColor: Theme.of(context).accentColor,
//           icon: Icon(Icons.image),
//           label: Text("Add Image")),
//     ],
//   );

// Column(
//   children: [
//     SizedBox(
//       height: 16,
//     ),
//     CircleAvatar(
//       radius: 37,
//       backgroundColor: Theme.of(context).accentColor,
//       backgroundImage:
//           _pickedImage != null ? FileImage(_pickedImage) : null,
//     ),
//     FlatButton.icon(
//         onPressed: _pickImage,
//         textColor: Theme.of(context).accentColor,
//         icon: Icon(Icons.image),
//         label: Text("Add Image")),
//   ],
// );
//   }
// }
