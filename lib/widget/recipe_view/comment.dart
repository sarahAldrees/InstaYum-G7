import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instayum/constant/app_globals.dart';

import 'package:instayum/model/comment_model.dart';
import 'package:instayum/model/reported_comment.dart';
import 'package:instayum/widget/add_recipe/recipe_service.dart';
import 'package:instayum/widget/recipe_view/user_information_design.dart';

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

FieldValue timestamp = FieldValue.serverTimestamp();

class Comments extends StatefulWidget {
  final String? _recipeId;
  final String? _authorId;
  String? comment;

  Comments(
    this._recipeId,
    this._authorId,
  );

  @override
  CommentState createState() => CommentState(
        this._recipeId,
        this._authorId,
        this.comment,
      );
}

class CommentState extends State<Comments> {
  final String? _recipeId;
  final String? _authorId;
  final String? comment;

  CommentState(
    this._recipeId,
    this._authorId,
    this.comment,
  );
  List<Widget> comments = [];
  TextEditingController _commentController = TextEditingController();

// --------------------------------------------------
  late CollectionReference databaseRef;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Widget _buildCommentList() {
    //User user = firebaseAuth.currentUser;

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
                  UserInformationDesign(
                    doc["userId"],
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

  String? userUsername = AppGlobals.userName;
  String? imageURL = AppGlobals.userImage;

  getData() {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser!;
    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser.uid)
        .snapshots()
        .listen((userData) {
      if (mounted)
        setState(() {
          Map user = userData.data()!;
          userUsername = user['username'];
          imageURL = user['image_url'];
        });
    });
  }

// -------- add a comment to firebase

  addComment(String commentText) async {
    final commentRef = Uuid().v4();
    Timestamp timestamp = Timestamp.now();
    DateTime now = DateTime.now();
    String formatter = 'yyyy-MM-dd - hh:mm:a';

    CommentModel comment = CommentModel(
      commentId: commentRef,
      userId: AppGlobals.userId,
      username: userUsername,
      imageUrl: imageURL,
      comment: commentText,
      recipeId: _recipeId,
      timestamp: timestamp,
      shownDate: DateFormat(formatter).format(now),
    );
    await firebaseFirestore
        .collection("recipes")
        .doc(_recipeId)
        .collection("comments")
        .doc(commentRef)
        .set(comment.toJson());
    if (_authorId != AppGlobals.userId)
      RecipeService().sendNotificationToAuthor(_recipeId, userUsername);
  }

  void initState() {
    super.initState();
    //0000
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
                            ? Icon(
                                Icons.send,
                                color: Colors.grey.shade300,
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
  final String? _authorId;
  final String? _recipeID;

  CommentList(
    this._authorId,
    this._recipeID,
  );
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  List<CommentModel> comments = [];

  late CollectionReference databaseRef;
  @override
  Widget build(BuildContext context) {
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
        // .collection("users")
        // .doc(widget._authorId)
        .collection("recipes")
        .doc(widget._recipeID)
        .collection("comments");
    setState(() {});
    databaseRef.orderBy('timestamp').snapshots().listen(
      (data) {
        comments.clear();
        //setState(() {
        // clear duplicate comments.
        data.docs.forEach((doc) {
          //int s = 1;

          // print(doc["username"]);
          // print(doc["imageUrl"]);
          // print(doc["comment"]);
          // add each comment doc in database to the list to show them in the screen
          Map data = doc.data() as Map<dynamic, dynamic>;

          comments.add(CommentModel(
            userId: data["userId"],
            username: data["username"],
            imageUrl: data["imageUrl"],
            comment: data["comment"],
            commentId: data["commentId"],
            recipeId: data["recipeId"],
            shownDate: data["shownDate"],
            timestamp: data["timestamp"],
          ));
        });
        if (this.mounted) {
          setState(() {});
        }
        // print('###');
        // print(comments[0].username);
        //});
      },
    ).onError((err) {
      print(" error in comments");
    });
  }

  void initState() {
    super.initState();
    getData();
  }

//******************************************************* */
  //---------------------------Delete a comment from firestore ------------------------------------------------**
  _DeletFirestoreComment(var key) async {
    print("-----------inside method_");
    print(key);
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(widget._recipeID)
        .collection("comments")
        .doc(key)
        .delete();
  }

  Widget reportOrDeleteIcon(CommentModel comment) {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser!.uid;
    print("----------------------------------------aa-----");
    print(comment.userId);
    print(AppGlobals.userId);
    print(_currentUser);
    print("----------------------------------------aa-----");

    if (_currentUser == comment.userId) {
      return IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  title: Column(
                    children: [
                      Text(
                        'Are you sure to delete the recipe?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, right: 30, left: 30, bottom: 0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Row(
                                          children: [
                                            Center(
                                                child: Icon(Icons
                                                    .delete_outline_rounded)),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 10),
                                                child: Text(
                                                  "Delete ",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFFeb6d44)),
                                    ),
                                    onPressed: () {
                                      _DeletFirestoreComment(
                                          comment.commentId!);
                                      Navigator.pop(context);
                                    }),
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Color(0xFFeb6d44),
                                    backgroundColor: Colors.white,
                                    //side: BorderSide(color: Colors.deepOrange, width: 1),
                                    elevation: 0,
                                    //minimumSize: Size(100, 50),
                                    //shadowColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )))
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.delete_outline,
            size: 20,
            color: Colors.red,
          ));
    } else {
      bool isEven = false;
      return IconButton(
          onPressed: () {
            List<String>? userAlreadyReported = [];

            FirebaseFirestore.instance
                .collection('admin')
                .doc("reportes")
                .collection("ReportedComment")
                .where('commentRef', isEqualTo: comment.commentId)
                .get()
                .then((doc) {
              if (doc != null && doc.docs.length > 0) {
                Map<String, dynamic>? data = doc.docs[0].data();
                ReprtedComment reprtedComment = ReprtedComment.fromJson(data);
                print("------------------------kk-----kk------mk--------");
                if (!reprtedComment.user_already_reported!
                    .contains(_currentUser)) {
                  reprtedComment.user_already_reported!.add(_currentUser);
                  //-------show dailoge about reson----------------
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        title: Column(
                          children: [
                            Text(
                              'Why are you reporting this?',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        actions: [
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, right: 30, left: 30, bottom: 0),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        child: Text(
                                          "Hurting others or bullying",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFeb6d44),
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("admin")
                                              .doc("reportes")
                                              .collection("ReportedComment")
                                              .doc(comment.commentId)
                                              .update({
                                            "Ignore": false,
                                            "no_reports": reprtedComment
                                                .user_already_reported!.length,
                                            "user_already_reported": FieldValue
                                                .arrayUnion(reprtedComment
                                                    .user_already_reported!),
                                            "bullying":
                                                reprtedComment.bullying! + 1,
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Fraudulent",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFeb6d44),
                                          backgroundColor: Colors.white,
                                          //side: BorderSide(color: Colors.deepOrange, width: 1),
                                          elevation: 0,
                                          //minimumSize: Size(100, 50),
                                          //shadowColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("admin")
                                              .doc("reportes")
                                              .collection("ReportedComment")
                                              .doc(comment.commentId)
                                              .update({
                                            "Ignore": false,
                                            "no_reports": reprtedComment
                                                .user_already_reported!.length,
                                            "user_already_reported": FieldValue
                                                .arrayUnion(reprtedComment
                                                    .user_already_reported!),
                                            "fraudulent":
                                                reprtedComment.fraudulent! + 1,
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Unethical",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFeb6d44),
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("admin")
                                              .doc("reportes")
                                              .collection("ReportedComment")
                                              .doc(comment.commentId)
                                              .update({
                                            "Ignore": false,
                                            "no_reports": reprtedComment
                                                .user_already_reported!.length,
                                            "user_already_reported": FieldValue
                                                .arrayUnion(reprtedComment
                                                    .user_already_reported!),
                                            "unethical":
                                                reprtedComment.unethical! + 1,
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "I don't Like it",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFeb6d44),
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("admin")
                                              .doc("reportes")
                                              .collection("ReportedComment")
                                              .doc(comment.commentId)
                                              .update({
                                            "Ignore": false,
                                            "no_reports": reprtedComment
                                                .user_already_reported!.length,
                                            "user_already_reported": FieldValue
                                                .arrayUnion(reprtedComment
                                                    .user_already_reported!),
                                            "IDontLike":
                                                reprtedComment.IDontLike! + 1,
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                          child: const Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                                child: Text(
                                                  "cancel",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFFeb6d44)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  )))
                        ],
                      );
                    },
                  );
                  //-------------------1---------------------

                  //-----------------------------------------------
                } else {
                  print("you are reported ");

                  //-------show dailoge about reson----------
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        title: Column(
                          children: [
                            Text(
                              'You have already reported !!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        actions: [
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, right: 30, left: 30, bottom: 0),
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                          child: const Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                                child: Text(
                                                  "OK     ",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFFeb6d44)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  )))
                        ],
                      );
                    },
                  );
                  //-----------------------------------------
                }
              } else {
                //-------------------------------
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      title: Column(
                        children: [
                          Text(
                            'Why are you reporting this?',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      actions: [
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(3, 0, 3, 15),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, right: 30, left: 30, bottom: 0),
                                child: Column(
                                  children: [
                                    TextButton(
                                      child: Text(
                                        "Hurting others or bullying",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFFeb6d44),
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        userAlreadyReported.add(_currentUser);

                                        ReprtedComment reprtedComment =
                                            ReprtedComment(
                                          commentRef: comment.commentId,
                                          commentDate: comment.shownDate,
                                          commentOwner: comment.username,
                                          commentText: comment.comment,
                                          recipeId: widget._recipeID,
                                          user_already_reported:
                                              userAlreadyReported,
                                          no_reports: 1,
                                          fraudulent: 0,
                                          bullying: 1,
                                          unethical: 0,
                                          IDontLike: 0,
                                          Ignore: false,
                                        );
                                        FirebaseFirestore.instance
                                            .collection("admin")
                                            .doc("reportes")
                                            .collection("ReportedComment")
                                            .doc(comment.commentId)
                                            .set(reprtedComment.toJson());
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Fraudulent",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFFeb6d44),
                                        backgroundColor: Colors.white,
                                        //side: BorderSide(color: Colors.deepOrange, width: 1),
                                        elevation: 0,
                                        //minimumSize: Size(100, 50),
                                        //shadowColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        userAlreadyReported.add(_currentUser);
                                        ReprtedComment reprtedComment =
                                            ReprtedComment(
                                          commentRef: comment.commentId,
                                          commentDate: comment.shownDate,
                                          commentOwner: comment.username,
                                          commentText: comment.comment,
                                          recipeId: widget._recipeID,
                                          user_already_reported:
                                              userAlreadyReported,
                                          no_reports: 1,
                                          fraudulent: 1,
                                          bullying: 0,
                                          unethical: 0,
                                          IDontLike: 0,
                                          Ignore: false,
                                        );
                                        FirebaseFirestore.instance
                                            .collection("admin")
                                            .doc("reportes")
                                            .collection("ReportedComment")
                                            .doc(comment.commentId)
                                            .set(reprtedComment.toJson());

                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Unethical",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFFeb6d44),
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        userAlreadyReported.add(_currentUser);
                                        ReprtedComment reprtedComment =
                                            ReprtedComment(
                                          commentRef: comment.commentId,
                                          commentDate: comment.shownDate,
                                          commentOwner: comment.username,
                                          commentText: comment.comment,
                                          recipeId: widget._recipeID,
                                          user_already_reported:
                                              userAlreadyReported,
                                          no_reports: 1,
                                          fraudulent: 0,
                                          bullying: 0,
                                          unethical: 1,
                                          IDontLike: 0,
                                          Ignore: false,
                                        );
                                        FirebaseFirestore.instance
                                            .collection("admin")
                                            .doc("reportes")
                                            .collection("ReportedComment")
                                            .doc(comment.commentId)
                                            .set(reprtedComment.toJson());

                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "I don't Like it",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      style: TextButton.styleFrom(
                                        primary: Color(0xFFeb6d44),
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        //----
                                        userAlreadyReported.add(_currentUser);
                                        ReprtedComment reprtedComment =
                                            ReprtedComment(
                                          commentRef: comment.commentId,
                                          commentDate: comment.shownDate,
                                          commentOwner: comment.username,
                                          commentText: comment.comment,
                                          recipeId: widget._recipeID,
                                          user_already_reported:
                                              userAlreadyReported,
                                          no_reports: 1,
                                          fraudulent: 0,
                                          bullying: 0,
                                          unethical: 0,
                                          IDontLike: 1,
                                          Ignore: false,
                                        );
                                        FirebaseFirestore.instance
                                            .collection("admin")
                                            .doc("reportes")
                                            .collection("ReportedComment")
                                            .doc(comment.commentId)
                                            .set(reprtedComment.toJson());
                                        //----

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 10),
                                              child: Text(
                                                "cancel    ",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFFeb6d44)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ],
                                )))
                      ],
                    );
                  },
                );

                //---------------------------

              }
            });
          },
          icon: Icon(
            Icons.flag_outlined,
            size: 20,
            color: Colors.red,
          ));
    }
  }

//********************************************************* */
//--------------------------------------------------------------------------
// ------------------- Design of each comment -----------------
  Widget designComment(CommentModel comment) => Container(
        child: Column(
          children: [
            Row(
              children: [
                UserInformationDesign(
                  comment.userId,
                  comment.username!,
                  comment.imageUrl!,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(comment.shownDate ?? '',
                        style: TextStyle(color: Colors.grey, fontSize: 12))),
                //************************************ */
                Spacer(),

                reportOrDeleteIcon(comment),

                //*************************************** */
              ],
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40.0, bottom: 10, right: 30, top: 10),
                  child: Text(comment.comment ?? ''),
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
