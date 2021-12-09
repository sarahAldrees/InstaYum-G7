import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImaged) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    ); //we can add imageQuality: 50 to reduce the qulaity if image to half so the size if it will reduce
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        CircleAvatar(
          radius: 37,
          backgroundColor: Theme.of(context).accentColor,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
            onPressed: _pickImage,
            textColor: Theme.of(context).accentColor,
            icon: Icon(Icons.image),
            label: Text("Add Image")),
      ],
    );
  }
}
