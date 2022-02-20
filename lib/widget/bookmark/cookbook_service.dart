import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/cookbook.dart';
import 'package:instayum/widget/pickers/cookbook_image_picker.dart';

class CookbookService {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future addCookbookToDatabase({String? cookBookIDAndTitle}) async {
    DateTime timestamp = DateTime.now();

    String? cookbookImageUrl = CookbookImagePickerState.uploadedFileURL;
    if (cookbookImageUrl == null) cookbookImageUrl = 'noImage';

    Cookbook cookbook = Cookbook(
        id: cookBookIDAndTitle,
        imageURLCookbook: cookbookImageUrl,
        cookbookTimestamp: timestamp);

    await firebaseFirestore
        .collection("users")
        .doc(AppGlobals.userId)
        .collection(
            "cookbooks") // create new collcetion of recipes inside user document to save all of the user's recipes
        .doc(cookBookIDAndTitle)
        .set(cookbook.toJson());
  }
}
