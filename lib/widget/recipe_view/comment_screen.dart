import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/commentObj.dart';
// import 'package:instayum1/widget/recipe_view/comments_sccreen.dart';
import 'package:instayum1/widget/recipe_view/image_and_username.dart';
import 'package:instayum1/widget/recipe_view/recipe_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:intl/intl.dart';

FieldValue timestamp = FieldValue.serverTimestamp();

class Comments extends StatefulWidget {
  final String _recipeId;
  final String _authorId;
  String comment;

  Comments(
    this._recipeId,
    this._authorId,
    // this.comment,
  );

  @override
  CommentState createState() => CommentState(
        this._recipeId,
        this._authorId,
        this.comment,
      );
}

class CommentState extends State<Comments> {
  final String _recipeId;

  final String _authorId;
  final String comment;
  TextEditingController _commentController = TextEditingController();

  CommentState(
    this._recipeId,
    this._authorId,
    this.comment,
    // this.databaseRef,
  );
// --------------------------------------------------
  CollectionReference databaseRef;
  Widget _buildCommentList() {
    //User user = firebaseAuth.currentUser;
    List<Widget> comments = [];

    databaseRef = FirebaseFirestore.instance
        .collection("users")
        .doc(_authorId)
        .collection("recipes")
        .doc(_recipeId)
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
    final _currentUser = usId.currentUser;
    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser.uid)
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
    final _commentRef = Uuid().v4();
    FirebaseFirestore.instance
        .collection("users")
        .doc(_authorId)
        .collection("recipes")
        .doc(_recipeId)
        .collection("comments")
        .doc(_commentRef)
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
    _commentController.addListener(() {
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
            widget._authorId,
            widget._recipeId,
          )),

          //------------------ build the TextField of comments screen ------------------
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: _commentController,
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
                        suffixIcon: _commentController.text.isEmpty ||
                                _commentController.text.trim() == ''
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
                                  if (_commentController.text.trim() == '') {
                                  } else {
                                    addComment(_commentController.text);
                                    // _addComment(controller.text);
                                    _commentController.clear();
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

class CommentList extends StatefulWidget {
  final String _authorId;
  final String _recipeID;

  CommentList(
    this._authorId,
    this._recipeID,
  );
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  List<commentObj> comments = [];

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

    return ListView(
        shrinkWrap: true,
        reverse: true,
        padding: EdgeInsets.all(12),
        children: [
          ...comments.map(designComment).toList(),
        ].reversed.toList());
  }

  getData() {
    // get data from database
    databaseRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget._authorId)
        .collection("recipes")
        .doc(widget._recipeID)
        .collection("comments");
    setState(() {});
    databaseRef.orderBy('timestamp').snapshots().listen((data) {
      comments.clear();
      //setState(() {
      // clear duplicate comments.
      data.docs.forEach((doc) {
        //int s = 1;

        // print(doc["username"]);
        // print(doc["imageUrl"]);
        // print(doc["comment"]);
        // add each comment doc in database to the list to show them in the screen

        comments.add(commentObj(
            username: doc["username"],
            commentImgUrl: doc["imageUrl"],
            comment: doc["comment"],
            date: doc["shownDate"]));
      });
      if (this.mounted) {
        setState(() {
          comments;
        });
      }
      // print('###');
      // print(comments[0].username);
      //});
    });
  }

  void initState() {
    super.initState();
    getData();
  }

// ------------------- Design of each comment -----------------
  Widget designComment(commentObj comment) => Container(
        child: Column(
          children: [
            Row(
              children: [
                userinfo(
                  comment.username,
                  comment.commentImgUrl,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(comment.date,
                        style: TextStyle(color: Colors.grey))),
              ],
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, bottom: 10, right: 30, top: 10),
                  child: Text(comment.comment),
                )),
            Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      );
}
