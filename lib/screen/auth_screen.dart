import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instayum1/main_pages.dart';
import 'package:instayum1/widget/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isSignUp,
    bool isDefaultImage,
    BuildContext ctx,
    // we recevice the context of form Scafflod to have the ability to push the snakcbar messages and to use theme color.
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isSignUp) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseFirestore.instance //just to store the username in the database
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          "username": "",
          "email": email,
          "image_url": "noImage",
        }); // we put initail empty values to avoid the exception (username[] was call on null)

        var url = ""; // NEW
        if (isDefaultImage) {
          url = "noImage";
          // to put the url part in the database with "noImage" if user does not choose an image
        } else {
          // to put the url part in database with user's image url
          // NEW
          final ref = FirebaseStorage.instance
              .ref()
              .child("user_image")
              .child(authResult.user.uid + "jpg");
          //we put the user is + jpg to be the name of the image and to make it unqie we use user id

          // we add onComplete to can add await
          await ref.putFile(image);

          url = await ref.getDownloadURL();
        }
        // here we put the real values
        await FirebaseFirestore
            .instance //just to store the username in the database
            .collection("users")
            .doc(authResult.user.uid)
            .update({
          "username": username,
          "email": email,
          "image_url": url,
        });
        //to move the user to the profile page (Mainpages) after he signup successfully
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainPages(),
          ),
        );
      } else {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
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
      // print(err);
      //to handel the error of firebase in case of entring non-valid email or password
      var message = "There is an error, please check your credentials!";

      if (err.message != null) {
        message = err.message.toString();
        message = "error ";
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor),
      );
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
          // print(err.code);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is invalid try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
      }
    } catch (error) {
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _isLoading = false;
        });
      }
      if (!(error is FirebaseAuthException)) {
        print('message in catch3:');
        print(error.message); // this is the actual error that you are getting
      }
      print('catch #3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
