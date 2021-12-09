//import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';
// import 'package:recipe_view/view_reicpe_flotingbutton.dart';

class RatingRecipe extends StatefulWidget {
  String _recipeId;
  String _autherId;

  RatingRecipe(this._recipeId, this._autherId);
  @override
  Rating createState() => Rating();
}

String _currentUserId;
double rating;
var numOfReviews;
var total;
var avg;

List<String> _usersAlredyRate;

class Rating extends State<RatingRecipe> {
  bool _findUser = false;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//getData() to get the data of users like username, image_url from database
  getData() async {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget._autherId)
        .collection("recipes")
        .doc(widget._recipeId)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      setState(() {
        //usersAlredyRate.clear();
        numOfReviews = userData.data()["num_of_reviews"];

        total = userData.data()["sum_of_all_rating"];

        avg = userData.data()["average_rating"];

        _usersAlredyRate = List.from(userData.data()["user_already_review"]);
        _currentUserId = _currentUser.uid;
        print("numOfRevewis===============");
        print(numOfReviews);
      });
    });
  }

  void initState() {
    super.initState();
    getData();
    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget _buildRatinBar() {
    return RatingBar.builder(
      direction: Axis.horizontal,
      //allowHalfRating: true,
      itemCount: 5,
      itemSize: 30,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (val) => setState(() {
        rating = val;
        print(rating);
      }),
    );
  }

  double doubleWithTwoDigits(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Widget build(BuildContext context) {
    return ActionButton(
      onPressed: () {
        for (int i = 0; i < _usersAlredyRate.length; i++) {
          if (_usersAlredyRate[i] == _currentUserId) {
            _findUser = true;
            break;
          }
        }
        ;

        if (!_findUser) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                title: Row(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(right: 20, left: 2),
                      padding: EdgeInsets.only(right: 12),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Colors.orange[800],
                          )),
                    ),
                    Text('Rate the recipe'),
                  ],
                ),
                content: Container(
                  height: 50,
                  child: Center(
                    child: _buildRatinBar(),
                  ),
                ),
                actions: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 0, left: 0, bottom: 0),
                      child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text("Rate"),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFeb6d44)),
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Thank you , you rated the recipe sucessfully"),
                                  backgroundColor: Colors.green.shade400),
                            );
                            Navigator.pop(context);
                            numOfReviews++;
                            print(numOfReviews);
                            if (!(rating == null || rating == 0))
                              total = total + rating;
                            print('total $total');
                            avg = total / numOfReviews;
                            avg = doubleWithTwoDigits(avg, 2);
                            print('Avg $avg');
                            _usersAlredyRate.add(_currentUserId);
                            for (int i = 0; i < _usersAlredyRate.length; i++) {
                              print("-------");
                              print(_usersAlredyRate[i]);
                            }

                            //----------uppdating data --------
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget._autherId)
                                .collection("recipes")
                                .doc(widget._recipeId)
                                .collection("rating")
                                .doc("recipeRating")
                                .update({
                              'sum_of_all_rating': total,
                              "num_of_reviews": numOfReviews,
                              "average_rating": avg,
                              "user_already_review":
                                  FieldValue.arrayUnion(_usersAlredyRate)
                            });
                          }),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                title: Text(' Thank you '),
                content: Text(' You have already rated it'),
                actions: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 0, left: 0, bottom: 0),
                      child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text("close"),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFeb6d44)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      icon: const Icon(Icons.star),
    );
  }
}
