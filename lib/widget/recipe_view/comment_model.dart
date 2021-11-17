import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String recipeId;
  final String userId;
  final String msg;

  Comment({
    this.recipeId,
    this.userId,
    this.msg,
  });

  @override
  CommentState createState() => CommentState(
        recipeId: this.recipeId,
        userId: this.userId,
        msg: this.msg,
      );
}

class CommentState extends State<Comment> {
  final String recipeId;
  final String userId;
  final String msg;
  TextEditingController commentController = TextEditingController();
  CommentState({
    this.recipeId,
    this.userId,
    this.msg,
  });

  _buildCommentList() {
    return Text('Helllooo');
  }

  addComment() {
    //commentRef;
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
            ],
          ),
        ],
      ),
    );
  }
}
