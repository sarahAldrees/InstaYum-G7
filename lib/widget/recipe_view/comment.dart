import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instayum/constant/app_globals.dart';

import 'package:instayum/model/comment_model.dart';
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
        // .collection("users")
        // .doc(widget._authorId)
        .collection("recipes")
        .doc(widget._recipeID)
        .collection("comments")
        .doc(key)
        .delete();
  }

  // deletCommentFromScreen(index) {
  //   comments.remove(index);
  // }

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
            // List userAlreadyReported = [];
            // bool isAlreadyReportedOn = false;
            // bool isUserAlreadyReported = false;
            // bool isEven = false;
            // int counter = 0;
            // databaseRef = FirebaseFirestore.instance
            //     .collection("users")
            //     .doc("7DNb5UkMjxVeMmY1Q7vPebXzdk73")
            //     .collection("ReportedComment");

            // databaseRef.snapshots().listen((data) {
            //   data.docs.forEach((doc) {
            //     if (!isAlreadyReportedOn) {
            //       //int s = 1;
            //       print("//---------------------------------------//");
            //       print(doc["commentRef"] == comment.commentRef);
            //       if (doc["commentRef"] == comment.commentRef) {
            //         isAlreadyReportedOn = true;
            //         print(isAlreadyReportedOn);
            //         print("ss");
            //         //==========check if user rated ===============
            //         userAlreadyReported =
            //             List.from(doc.data()["user_already_reported"]);
            //         counter = userAlreadyReported.length;

            //         print(isAlreadyReportedOn);
            //         for (int i = 0; i < userAlreadyReported.length; i++) {
            //           if (userAlreadyReported[i] == _currentUser) {
            //             isUserAlreadyReported = true;
            //             print(isAlreadyReportedOn);

            //             break;
            //           }
            //         }
            //         ;
            //       }
            //     }

            //     print(isAlreadyReportedOn);
            //   });

            //   if (isAlreadyReportedOn == false && isEven == false) {
            //     print("----------------------------------------444");
            //     print(isAlreadyReportedOn);
            //     userAlreadyReported.add(_currentUser);
            //     FirebaseFirestore.instance
            //         .collection("users")
            //         .doc("7DNb5UkMjxVeMmY1Q7vPebXzdk73")
            //         .collection("comments")
            //         .doc(comment.commentRef)
            //         .set({
            //       "commentRef": comment.commentRef,
            //       "recipeAuther": widget._authorId,
            //       "recipeId": widget._recipeID,
            //       "commentOwner": comment.username,
            //       "imageURLComment": comment.commentImgUrl,
            //       "commentText": comment.comment,
            //       "commentDate": comment.date,
            //       "user_already_reported":
            //           FieldValue.arrayUnion(userAlreadyReported),
            //       "no_reports": counter,
            //     });

            //     showDialog<void>(
            //       context: context,
            //       barrierDismissible: false,
            //       builder: (context) {
            //         return AlertDialog(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(15)),
            //           ),
            //           title: Text(' Thank you for report'),
            //           content: Text(
            //               ' and Appropriate action will be taken by the support team'),
            //           actions: [
            //             Container(
            //               width: double.infinity,
            //               margin: EdgeInsets.all(0),
            //               child: Padding(
            //                 padding: const EdgeInsets.only(
            //                     top: 15, right: 0, left: 0, bottom: 0),
            //                 child: ElevatedButton(
            //                     child: Padding(
            //                       padding:
            //                           const EdgeInsets.symmetric(vertical: 10),
            //                       child: Text("close"),
            //                     ),
            //                     style: ButtonStyle(
            //                       backgroundColor: MaterialStateProperty.all(
            //                           Color(0xFFeb6d44)),
            //                     ),
            //                     onPressed: () {
            //                       Navigator.pop(context);
            //                     }),
            //               ),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   } else {
            //     if (isUserAlreadyReported == false) {
            //       print("// in sid if -----------------");
            //       userAlreadyReported.add(_currentUser);
            //       FirebaseFirestore.instance
            //           .collection("users")
            //           .doc("7DNb5UkMjxVeMmY1Q7vPebXzdk73")
            //           .collection("ReportedComment")
            //           .doc(comment.commentRef)
            //           .set({
            //         "commentRef": comment.commentRef,
            //         "recipeAuther": widget._authorId,
            //         "recipeId": widget._recipeID,
            //         "commentOwner": comment.username,
            //         "imageURLComment": comment.commentImgUrl,
            //         "commentText": comment.comment,
            //         "commentDate": comment.date,
            //         "user_already_reported":
            //             FieldValue.arrayUnion(userAlreadyReported),
            //       });
            //       isUserAlreadyReported = true;
            //       showDialog<void>(
            //         context: context,
            //         barrierDismissible: false,
            //         builder: (context) {
            //           return AlertDialog(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(15)),
            //             ),
            //             title: Text(' Thank you for helping'),
            //             content: Text(' You have already rated it'),
            //             actions: [
            //               Container(
            //                 width: double.infinity,
            //                 margin: EdgeInsets.all(0),
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(
            //                       top: 15, right: 0, left: 0, bottom: 0),
            //                   child: ElevatedButton(
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             vertical: 10),
            //                         child: Text("close"),
            //                       ),
            //                       style: ButtonStyle(
            //                         backgroundColor: MaterialStateProperty.all(
            //                             Color(0xFFeb6d44)),
            //                       ),
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       }),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     } else {
            //       print("inside else");
            //       if (isUserAlreadyReported) {
            //         showDialog<void>(
            //           context: context,
            //           barrierDismissible: false,
            //           builder: (context) {
            //             return AlertDialog(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.all(Radius.circular(15)),
            //               ),
            //               title: Text(' Thank you '),
            //               content: Text(' You have already rated it'),
            //               actions: [
            //                 Container(
            //                   width: double.infinity,
            //                   margin: EdgeInsets.all(0),
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(
            //                         top: 15, right: 0, left: 0, bottom: 0),
            //                     child: ElevatedButton(
            //                         child: Padding(
            //                           padding: const EdgeInsets.symmetric(
            //                               vertical: 10),
            //                           child: Text("close"),
            //                         ),
            //                         style: ButtonStyle(
            //                           backgroundColor:
            //                               MaterialStateProperty.all(
            //                                   Color(0xFFeb6d44)),
            //                         ),
            //                         onPressed: () {
            //                           Navigator.pop(context);
            //                         }),
            //                   ),
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       }
            //     }
            //   }
            //   isEven = false;
            // });
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
                SizedBox(
                  width: 0,
                ),
                // InkWell(
                //     onTap: () {},
                //     child: Icon(
                //       Icons.flag_outlined,
                //       color: Colors.black,
                //     )),

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
