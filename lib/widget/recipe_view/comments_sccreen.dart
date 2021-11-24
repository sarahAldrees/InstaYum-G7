import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/checkboxState.dart';
import 'package:instayum1/model/commentState.dart';
import 'package:instayum1/widget/recipe_view/image_and_username.dart';

class CommentList extends StatefulWidget {
  final String authorId;
  final String recipeID;

  CommentList({
    this.authorId,
    this.recipeID,
  });
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  bool outvalue = false; //outvalue is change the state of check list
  var checkedstyle = TextDecoration.none;
  List<commentState> comments = [];
  CollectionReference databaseRef;
  @override
  Widget build(BuildContext context) {
    // ----------------------------------
    // databaseRef = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(widget.authorId)
    //     .collection("recpies")
    //     .doc(widget.recipeID)
    //     .collection("comments");

    // databaseRef.snapshots().listen((data) {
    //   data.docs.forEach((doc) {
    //     //int s = 1;

    //     bool enter = true;
    //     if (enter) {
    //       print(doc["username"]);
    //       print(doc["imageUrl"]);
    //       print(doc["comment"]);
    //       comments.add(commentState(
    //           username: doc["username"],
    //           commentImgUrl: doc["imageUrl"],
    //           comment: doc["comment"]));
    //     }
    //     print('@@@@@@@@@@@@@@@@@@@@');
    //     print(comments[0].username);
    //     enter = false;
    //   });
    // });
    // --------

    return ListView(padding: EdgeInsets.all(12), children: [
      ...comments.map(comment).toList(),
    ]);
  }

  getData() {
    databaseRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.authorId)
        .collection("recpies")
        .doc(widget.recipeID)
        .collection("comments");

    databaseRef.snapshots().listen((data) {
      setState(() {
        data.docs.forEach((doc) {
          //int s = 1;

          print(doc["username"]);
          print(doc["imageUrl"]);
          print(doc["comment"]);
          comments.add(commentState(
              username: doc["username"],
              commentImgUrl: doc["imageUrl"],
              comment: doc["comment"]));

          print('@@@@@@@@@@@@@@@@@@@@');
          print(comments[0].username);
        });
      });
    });
  }

  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
  }

  Widget comment(commentState comment) => Container(
        child: Column(
          children: [
            userinfo(
              comment.username,
              comment.commentImgUrl,
            ),
            Text(comment.comment),
            Divider(),
          ],
        ),

        // controlAffinity: ListTileControlAffinity.leading,
        // activeColor: Color(0xFFeb6d44),
        // value: checkbox.outvalue,
        // title: Text(checkbox.title,
        //     style: TextStyle(
        //       decoration: checkbox.checkedstyle,
        //       decorationColor: Color(0xFFeb6d44),
        //       decorationThickness: 4,
        //     )),
        // onChanged: (value) {
        //   setState(() {
        //     checkbox.outvalue = value;
        //     if (checkbox.outvalue == true) {
        //       checkbox.checkedstyle = TextDecoration.lineThrough;
        //     } else {
        //       checkbox.checkedstyle = TextDecoration.none;
        //     }
        //   });
      );
}
