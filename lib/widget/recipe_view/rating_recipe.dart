import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum1/widget/recipe_view/view_reicpe_flotingbutton.dart';
// import 'package:recipe_view/view_reicpe_flotingbutton.dart';

class Rating_recipe extends StatefulWidget {
  String recipeId;
  String autherId;
  Rating_recipe(this.recipeId, this.autherId);
  @override
  Rating createState() => Rating();
}

double rating;
var numOfRevewis;
var total;
var avg;

class Rating extends State<Rating_recipe> {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//getData() to get the data of users like username, image_url from database
  getData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.autherId)
        .collection("recpies")
        .doc(widget.recipeId)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      setState(() {
        numOfRevewis = userData.data()["no_of_pepole"];

        total = userData.data()["sum_of_all_rating"];

        avg = userData.data()["average_rating"];
      });
    });
  }

  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget _buildRatinBar() {
    print("numOfRevewis===============");
    print(total);
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

  double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Widget build(BuildContext context) {
    return ActionButton(
      onPressed: () {
        showDialog<void>(
          context: context,
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
                        onPressed: () {
                          Navigator.pop(context);
                          numOfRevewis++;
                          print(numOfRevewis);
                          total = total + rating;
                          print('total $total');
                          avg = total / numOfRevewis;
                          avg = dp(avg, 2);
                          print('Avg $avg');
                          //avg = pow(avg, 2);
                          // print('Avg $avg');

                          //----------uppdating data --------
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.autherId)
                              .collection("recpies")
                              .doc(widget.recipeId)
                              .collection("rating")
                              .doc("recipeRating")
                              .update({
                            'sum_of_all_rating': total,
                            "no_of_pepole": numOfRevewis,
                            "average_rating": avg,
                          });
                        }),
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.star),
    );
  }
}
