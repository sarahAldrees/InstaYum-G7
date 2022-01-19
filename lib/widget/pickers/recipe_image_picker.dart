import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RecipeImagePicker extends StatefulWidget {
  @override
  RecipeImagePickerState createState() => RecipeImagePickerState();
}

class RecipeImagePickerState extends State<RecipeImagePicker> {
  bool _isloading = false; // to show the progress circle
  File _image;
  static String uploadedFileURL;
  List<Asset> images = List<Asset>();
  static List<String> imagesURLs = List<String>();

  String _error = 'No Error Dectected';
  var width;
  var height;

  @override
  void initState() {
    super.initState();
    //to solve the exception of the default image
    imagesURLs.add(
        "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43");
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    // we added the default image in the begining of process to avoid an exception
    imagesURLs = [
      "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43"
    ];
    // RecipeImagePickerState.imagesURLs.add(
    //     "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43");

    List<Asset> resultList = List<Asset>();

    List<File> fikles = List<File>();
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6, // 4 or 6?
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "Recipe images",
        ),
      );
// we make for loop to load many images
      for (Asset i in resultList) {
        print("IMAGE");
        print(i.name + " " + i.getByteData().toString());
        print("END OF NAME");

        setState(() {
          _isloading = true;
        });
        final FirebaseAuth _auth = FirebaseAuth.instance;

        FirebaseStorage storageReference = FirebaseStorage.instance;
//-------------------To convert to file--------------------------------

        final byteData = await i.getByteData();
        final tempFile =
            File("${(await getTemporaryDirectory()).path}/${i.name}");
        final imageFile = await tempFile.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
//----------------------------------------------------
        Reference ref = storageReference
            .ref()
            .child('recpie_image/${Path.basename(imageFile.path)}}');

        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.then((res) {
          print('File Uploaded');
          res.ref.getDownloadURL().then((fileURL) {
            // imagesURLs.add(fileURL);
            print('here in image class ');
            print(fileURL);
            print('the id in image class is  ');
            // to add https://
            // to add the image
            imagesURLs.add(fileURL);
// to remove the default image
            imagesURLs.remove(
                "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43");
            print("set state work now!");
          }).then((nothing) async {
            // nothing mean null, but null cause an error
            setState(() {
              _isloading = false;
            });
          });
        });
      }
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            // Center(child: Text('Error: $_error')),
            Padding(padding: EdgeInsets.only(top: 15)),
            images.isNotEmpty
                ? Container(
                    margin: EdgeInsets.all(15),
                    child: CarouselSlider.builder(
                      itemCount: imagesURLs.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 175,
                        reverse: false,
                        aspectRatio: 5.0,
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            //ClipRRect for image border radius
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imagesURLs[i],
                                width: 500,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            var url = imagesURLs[i];
                            print(url.toString());
                          },
                        );
                      },
                    ),
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
                    onPressed: loadAssets,
                    //chooseFile,
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
