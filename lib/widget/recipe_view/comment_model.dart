import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/recipe_view/recipe_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comments extends StatefulWidget {
  final String userId;
  final String recipeId;
  final String comment;

  Comments({
    this.userId,
    this.recipeId,
    this.comment,
  });

  @override
  CommentState createState() => CommentState(
        recipeId: this.recipeId,
        userId: this.userId,
        comment: this.comment,
      );
}

class CommentState extends State<Comments> {
  final String recipeId;
  final String userId;
  final String comment;
  TextEditingController commentController = TextEditingController();
  CommentState({
    this.recipeId,
    this.userId,
    this.comment,
  });

  _buildCommentList() {
    return StreamBuilder(
        stream: recipe_view.commentRef
            .doc(recipeId)
            .collection('comments')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }

  addComment() async {
    final FirebaseAuth userId = FirebaseAuth.instance;
    final currentUser = await userId.currentUser;
    recipe_view.commentRef.doc(recipeId).collection("comments").add({
      "username": currentUser.uid,
      "reciepeId": recipeId,
      "comment": commentController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Comments'),
        backgroundColor: Color(0xFFeb6d44),
      ),
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
                          onPressed: () {
                            if (commentController.text.trim() == '') {
                            } else {
                              addComment();
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
          backgroundImage: NetworkImage(
              'https://www.eatthis.com/wp-content/uploads/sites/4/2019/11/whole-grain-pancake-stack.jpg?fit=1200%2C879&ssl=1'),
        ),
        title: Text(comment),
      ),
      Divider(),
    ]);
  }
}
