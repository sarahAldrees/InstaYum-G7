import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/comment_obj.dart';
import 'package:instayum1/widget/recipe_view/user_information_design.dart';

class ReportedCommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<ReportedCommentList> {
  List<CommentObj> comments = [];
  CollectionReference databaseRef;
  static String autherId = "";
  static String recipeId = "";
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
        padding: EdgeInsets.all(12),
        children: [
          ...comments.map(designComment).toList(),
        ].reversed.toList());
  }

  getData() {
    // get data from database
    databaseRef = FirebaseFirestore.instance
        .collection("users")
        .doc("7DNb5UkMjxVeMmY1Q7vPebXzdk73")
        .collection("comments");
    setState(() {});
    databaseRef.snapshots().listen((data) {
      comments.clear();
      //setState(() {
      // clear duplicate comments.

      data.docs.forEach((doc) {
        //int s = 1;
        autherId = doc["recipeAuther"];
        recipeId = doc["recipeId"];
        // print(doc["username"]);
        // print(doc["imageUrl"]);
        // print(doc["comment"]);
        // add each comment doc in database to the list to show them in the screen
        print(doc["commentOwner"]);
        comments.add(CommentObj(
          username: doc["commentOwner"],
          commentImgUrl: doc["imageURLComment"],
          comment: doc["commentText"],
          date: doc["commentDate"],
          commentRef: doc["commentRef"],
        ));
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

//******************************************************* */
  //---------------------------Delete a comment from firestore ------------------------------------------------**
  _DeletFirestoreComment(var key) async {
    print("-----------inside method_");
    print(key);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(autherId)
        .collection("recipes")
        .doc(recipeId)
        .collection("comments")
        .doc(key)
        .delete();

    await FirebaseFirestore.instance
        .collection("users")
        .doc("7DNb5UkMjxVeMmY1Q7vPebXzdk73")
        .collection("comments")
        .doc(key)
        .delete();
  }

  Widget repordelIcon(String commentRef) {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser.uid;

    return IconButton(
        onPressed: () {
          _DeletFirestoreComment(commentRef);
        },
        icon: Icon(
          Icons.delete_outline,
          size: 20,
          color: Colors.red,
        ));
  }

//********************************************************* */
//--------------------------------------------------------------------------
// ------------------- Design of each comment -----------------
  Widget designComment(CommentObj comment) => Container(
        child: Column(
          children: [
            Row(
              children: [
                UserInformationDesign(
                  comment.username,
                  comment.commentImgUrl,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(comment.date,
                        style: TextStyle(color: Colors.grey))),
                //************************************ */
                SizedBox(
                  width: 20,
                ),
                // InkWell(
                //     onTap: () {},
                //     child: Icon(
                //       Icons.flag_outlined,
                //       color: Colors.black,
                //     )),

                InkWell(
                  onTap: () {
                    // var comkey = snapshot Key;
                    // print(comkey);
                    // // userDirections.length > 1 to prevent deleting the field if there is only one field
                    // _DeletFirestoreComment(comkey);
                    // refresh the screen
                    print("--------------------------");
                    print(comment.commentRef);
                    _DeletFirestoreComment(comment.commentRef);
                    // setState(() {});
                    AlertDialog(
                      title: Text("Are you sure to delete the comment ?"),
                      actions: [
                        Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(right: 20, left: 2),
                              padding: EdgeInsets.only(right: 12),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  )),
                            ),
                            Text('Delete'),
                          ],
                        ),
                      ],
                    );
                  },
                  child: repordelIcon(comment.commentRef),
                )
                //*************************************** */
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
