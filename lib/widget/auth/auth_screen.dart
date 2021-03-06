import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/main_pages.dart';
import 'package:instayum/widget/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

//
class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  bool _isLoading = false;
  static bool isAdmin = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File? image,
    bool isSignUp,
    bool isDefaultImage,
    BuildContext ctx,
    // we recevice the context of form Scafflod to have the ability to push the snakcbar messages and to use theme color.
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential authResult;
      String? token = await firebaseMessaging.getToken();
      AppGlobals.pushToken = token;
      String url = "noImage";

      if (isSignUp) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (authResult.user != null) {
          FirebaseFirestore
              .instance //just to store the username in the database
              .collection("users")
              .doc(authResult.user!.uid)
              .set({
            "username": "",
            "email": email,
            "image_url": "noImage",
            "pushToken": AppGlobals.pushToken,
          }); // we put initail empty values to avoid the exception (username[] was call on null)

          var url = ""; // NEW
          if (isDefaultImage) {
            url = "noImage";
            // to put the url part in the database with "noImage" if user does not choose an image
          } else {
            // to put the url part in database with user's image url
            final ref = FirebaseStorage.instance
                .ref()
                .child("user_image")
                .child(authResult.user!.uid + "jpg");
            //we put the user is + jpg to be the name of the image and to make it unqie we use user id

            // we add onComplete to can add await
            await ref.putFile(image!); //!

            url = await ref.getDownloadURL();
          }
          // here we put the real values
          DateTime timestamp = DateTime.now();
          await FirebaseFirestore
              .instance //just to store the username in the database
              .collection("users")
              .doc(authResult.user!.uid)
              .update({
            "username": username,
            "email": email,
            "image_url": url,
          });
          await FirebaseFirestore.instance
              .collection("users")
              .doc(authResult.user!.uid)
              .collection("cookbooks")
              .doc("All bookmarked recipes")
              .set({
            "cookbook_id": "All bookmarked recipes",
            "cookbook_img_url": "noImage", // to set the default image
            "timestamp": timestamp,
            "bookmarkedList": FieldValue.arrayUnion([]),
          });
          //to move the user to the profile page (Mainpages) after he signup successfully
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainPages(),
            ),
          );
        } else {
          // the user is null
          throw PlatformException(
            code: 'null_user',
            message: 'Something went wrong. Please try again.',
          );
        }
      } else {
        //log in
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //update push token
        await firebaseFirestore
            .collection("users")
            .doc(authResult.user!.uid)
            .update({"pushToken": AppGlobals.pushToken});

        // to move the user to the profile page (Mainpages) after he login successfully

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainPages(),
          ),
        );
      }
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      print('catch #1');

      var message = "There is an error, please check your credentials!";

      if (err.message != null) {
        message = err.message.toString();
        message = "error ";
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor),
      );
      print(message);
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });

      print('catch #2');
      print(error.code);
      switch (error.code) {
        case 'wrong-password':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is incorrect try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        case 'user-not-found':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is incorrect try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        case 'email-already-in-use':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email address is taken"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        default:
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is invalid try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
      }
    } catch (error) {
      print('catch #3');
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _isLoading = false;
        });
      }
      if (!(error is FirebaseAuthException)) {
        print(
            error.toString()); // this is the actual error that you are getting
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
