import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/image_and_username.dart';
import 'package:instayum1/widget/recipe_view/recipe_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
//import 'package:cloud_firestore_platform_interface/src/timestamp.dart';

class Comments extends StatefulWidget {
  final String userId;
  final String recipeId;
  final String authorId;
  final String comment;

  Comments({
    this.userId,
    this.recipeId,
    this.authorId,
    this.comment,
  });

  @override
  CommentState createState() => CommentState(
        recipeId: recipeId,
        userId: this.userId,
        authorId: this.authorId,
        comment: this.comment,
      );
}

class CommentState extends State<Comments> {
  final String recipeId;
  final String userId;
  final String authorId;
  final String comment;
  TextEditingController commentController = TextEditingController();

  CommentState({
    this.recipeId,
    this.userId,
    this.authorId,
    this.comment,
  });
// --------------------------------------------------

  Widget _buildCommentList() {
    //User user = firebaseAuth.currentUser;
    List<Widget> comments = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(authorId)
        .collection("recpies")
        .doc(recipeId)
        .collection("comments")
        .snapshots()
        .listen((data) {
      bool enter = true;
      data.docs.forEach((doc) {
        //int s = 1;

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
      });
      enter = false;
      //
    });

    //     .get()
    //     .then((querySnapshot) {
    //   querySnapshot.docs.forEach((doc) => {
    //         comments.add(
    //           Column(
    //             children: [
    //               userinfo(
    //                 doc.data()['username'],
    //                 doc.data()['imageUrl'],
    //               ),
    //               Text(doc.data()['comment']),
    //               Divider(),
    //             ],
    //           ),
    //         ),
    //       });
    // });

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

  // _buildCommentList() {
  //   return StreamBuilder(
  //       stream: recipe_view.commentRef
  //           .doc(recipeId)
  //           .collection('comments')
  //           .orderBy('timestamp', descending: false)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return CircularProgressIndicator();
  //         }
  //         List<Comment> comments = [];
  //         snapshot.data.docs.forEach((doc) {
  //           comments.add(Comment.fromDocument(doc));
  //         });
  //         return ListView(
  //           children: comments,
  //         );
  //       });
  // }

// -------- add a comment to firebase

  addComment(String com) async {
    //User user = _firebaseAuth.currentUser;
    //Timestamp timestamp;
    final commentRef = Uuid().v4();
    FirebaseFirestore.instance
        .collection("users")
        .doc(authorId)
        .collection("recpies")
        .doc(recipeId)
        .collection("comments")
        .doc(commentRef)
        .set({
      "username": userUsername,
      "reciepeId": "2cf0fbeb-957a-4330-96b3-36bc2fbfe080",
      "imageUrl": imageURL,
      //"timestamp": timestamp,
      "comment": com,
    });
  }

  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
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
          Expanded(child: _buildCommentList()),

          //------------------ build the TextField of comments screen ------------------
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: commentController,
                    cursorColor: Colors.red,
                    // keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.orange)),
                        suffixIcon: IconButton(
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

// -------- class of a comment
class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String imageUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.imageUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      imageUrl: doc['imageUrl'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(comment),
      ),
      Divider(),
    ]);
  }
}
