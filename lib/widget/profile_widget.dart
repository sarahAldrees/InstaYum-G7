// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileWidget extends StatefulWidget {
//   final String imagePath;
//   final VoidCallback onClicked;

//   const ProfileWidget({
//     Key key,
//     @required this.imagePath,
//     @required this.onClicked,
//   }) : super(key: key);

//   @override
//   ProfileWidgetState createState() => ProfileWidgetState();
// }

// class ProfileWidgetState extends State<ProfileWidget> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   String userUsername = "";
//   String imageURL = "";

// //getData() to get the data of users like username, image_url from database
//   void getData() async {
//     User user = _firebaseAuth.currentUser;
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(user.uid)
//         .snapshots()
//         .listen((userData) {
//       setState(() {
//         userUsername = userData.data()['username'];
//         imageURL = userData.data()['image_url'];
//       });
//     });
//   }

//   void initState() {
//     super.initState();
//     getData(); //we call the method here to get the data immediately when init the page.
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;

//     return Center(child: buildImage());
//   }

//   Widget buildImage() {
//     final image = NetworkImage(imageURL);

//     return ClipOval(
//       child: Material(
//         color: Colors.grey.shade400,
//         child: Ink.image(
//           image: image,
//           fit: BoxFit.cover,
//           width: 100,
//           height: 100,
//           child:
//               InkWell(onTap: widget.onClicked), // i suggest to delete the edit.
//         ),
//       ),
//     );
//   }
// }
