import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/bookmark/bookmarks_recipes_screen.dart';
import 'package:instayum1/widget/bookmark/cookbook_item.dart';

class chekcingBookmarke extends StatefulWidget {
  @override
  String _autherId;
  String _recipeid;

  chekcingBookmarke(this._recipeid, this._autherId);

  State<chekcingBookmarke> createState() => chekcingBookmarkeState();
}

class chekcingBookmarkeState extends State<chekcingBookmarke> {
  bool recipeExist = false;
  Widget bookmarkIcon() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("cookbooks")
        .doc("Default cookbook")
        .collection("bookmarked_recipe")
        .snapshots()
        .listen((data) {
      recipeExist = false;
      data.docs.forEach(
        (doc) {
          if (doc.data()['recipeId'] == widget._recipeid) {
            recipeExist = true;
          }
        },
      );
      setState(() {});
    });

    // });
    // });

    print(recipeExist);
    if (recipeExist) {
      return IconButton(
          icon: Icon(
            Icons.bookmark,
            //  Icons.ios_share,
            size: 26,
          ),
          onPressed: () {
//------------------delete from bookmark recipe--------------
            FirebaseFirestore.instance
                .collection("bookmarked_recipe")
                .get()
                .then((resultedId) {
              for (DocumentSnapshot ds in resultedId.docs) {
                //ds.reference.delete();
                print("esultedId.docs");
              }
            });

//-------------------------------------------------
          });
    } else {
      return IconButton(
          icon: Icon(
            Icons.bookmark_add_outlined,
            size: 26,
            // color: Color(0xFFeb6d44),
          ),
          onPressed: () {
            // bookmarked_recipesState.getCookbookObjects();

            setState(() {
              cookbook_item.isBrowse = false;
            });

            ///------------------bookmark --------
            showModalBottomSheet(
                isDismissible: false,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                context: context,
                builder: (context) {
                  return bookmarked_recipes(widget._autherId, widget._recipeid);
                  // return bookmarked_recipes();
                });

            //setstat :change the kind of ici=on and add it to bookmark list
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bookmarkIcon();
  }
}
