import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/comments_sccreen.dart';
import 'package:instayum1/widget/recipe_view/image_and_username.dart';
import 'package:instayum1/widget/recipe_view/recipe_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:intl/intl.dart';

FieldValue timestamp = FieldValue.serverTimestamp();

class Comments extends StatefulWidget {
  final String recipeId;
  final String authorId;
  final String comment;

  Comments({
    this.recipeId,
    this.authorId,
    this.comment,
  });

  @override
  CommentState createState() => CommentState(
        recipeId: recipeId,
        authorId: this.authorId,
        comment: this.comment,
      );
}

class CommentState extends State<Comments> {
  final String recipeId;

  final String authorId;
  final String comment;
  TextEditingController commentController = TextEditingController();

  CommentState({
    this.recipeId,
    this.authorId,
    this.comment,
    this.databaseRef,
  });
// --------------------------------------------------
  CollectionReference databaseRef;
  Widget _buildCommentList() {
    //User user = firebaseAuth.currentUser;
    List<Widget> comments = [];

    databaseRef = FirebaseFirestore.instance
        .collection("users")
        .doc(authorId)
        .collection("recipes")
        .doc(recipeId)
        .collection("comments");

    databaseRef.snapshots().listen((data) {
      comments.clear();

      data.docs.forEach((doc) {
        //int s = 1;
        bool enter = true;
        if (enter) {
          print(doc["username"]);
          print(doc["imageUrl"]);
          print(doc["comment"]);
          comments.add(
            Container(
              child: Column(
                children: [
                  userinfo(
                    doc["username"],
                    doc["imageUrl"],
                  ),
                  Text(doc["comment"]),
                  Divider(),
                ],
              ),
            ),
          );
        }
        enter = false;
      });
    });

    return ListView(
      children: comments,
    );
  }

  String userUsername = "";
  String imageURL = "";

  getData() {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final currentUser = usId.currentUser;
    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        userUsername = userData.data()['username'];
        imageURL = userData.data()['image_url'];
      });
    });
    print('User id');
    // print(currentUser.uid);
    print('Image Url');
    print(imageURL);
  }

// -------- add a comment to firebase

  addComment(String com) async {
    final commentRef = Uuid().v4();
    FirebaseFirestore.instance
        .collection("users")
        .doc(authorId)
        .collection("recipes")
        .doc(recipeId)
        .collection("comments")
        .doc(commentRef)
        .set({
      "username": userUsername,
      "reciepeId": "2cf0fbeb-957a-4330-96b3-36bc2fbfe080",
      "imageUrl": imageURL,
      "timestamp": timestamp,
      "shownDate": DateFormat('yyyy-MM-dd – hh:mm:a').format(DateTime.now()),
      "comment": com,
    });
  }

  void initState() {
    super.initState();
    getData();
    commentController.addListener(() {
      setState(() {});
    }); //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Comments'),
        backgroundColor: Color(0xFFeb6d44),
      ),

      // shows the page of comments which consists of list of comments and the field text
      body: Column(
        children: <Widget>[
          Expanded(
              child: CommentList(
            authorId: widget.authorId,
            recipeID: widget.recipeId,
          )),

          //------------------ build the TextField of comments screen ------------------
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: commentController,
                    cursorColor: Colors.red,
                    maxLines: null,
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.orange)),
                        suffixIcon: commentController.text.isEmpty ||
                                commentController.text.trim() == ''
                            ? IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.grey.shade300,
                                ),
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Color(0xFFeb6d44),
                                ),
                                // ------- if there is no text in the textfield
                                //don't add the empty comment to the comments list

                                onPressed: () {
                                  if (commentController.text.trim() == '') {
                                  } else {
                                    addComment(commentController.text);
                                    // _addComment(controller.text);
                                    commentController.clear();
                                  }
                                },
                              ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Add  a comment..."),
                  ),
                ),
              ),
              //---------------------------------------------------------------
            ],
          ),
        ],
      ),
    );
  }
}
