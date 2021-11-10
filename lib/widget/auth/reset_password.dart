import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instayum1/screen/auth_screen.dart';

class RestPassword extends StatefulWidget {
  @override
  _RestPasswordState createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  final _formKey = GlobalKey<FormState>();

  var _userEmail = "";

  bool _isValidEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(email);
  }

  void _trySendRequest() async {
    _formKey.currentState.save();

    final isValidForm = _formKey.currentState.validate();

    bool _switchToLogin = false;
    if (isValidForm) {
      try {
        final _auth = await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _userEmail);
        _switchToLogin = true;
      } on PlatformException catch (err) {
        print(err.code);
        _switchToLogin = false;
      } catch (err) {
        _switchToLogin = false;
        if (err.code == "user-not-found") {
          showAlertDialogUserNotFound(context);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //       content: Text("The email is incorrect try again!"),
          //       backgroundColor: Theme.of(context).errorColor),
          // );
        }
      }
    }
    if (_switchToLogin) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("A reset request was sent to your email: " + _userEmail),
      //   backgroundColor: Colors.green,
      // ));
      showAlertDialogSentRequest(context);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => AuthScreen()));
      // Navigator.of(context).pop();
    }
  }

  showAlertDialogUserNotFound(BuildContext context) {
    // set up the button
    Widget okButton = RaisedButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Error",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "No user found",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogSentRequest(BuildContext context) {
    // set up the button
    Widget okButton = RaisedButton(
      child: Text("OK"),
      onPressed: () {
        int count = 0;
        Navigator.of(context).popUntil((_) =>
            count++ >=
            2); // To pop 2 screen at the same time 1-The alert dialog 2- The reset page, back to login page
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Email Link Sent",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      ),
      content: Text(
        "A reset request was sent to your email: " + _userEmail,
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          //   Card(),
          // Padding(padding: EdgeInsets.only(top: 100)),
          Center(
            child: Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Reset The Password",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).accentColor),
                        ),
                        TextFormField(
                          key: ValueKey(
                              "email"), // علشان اذا حولت من لوق ان الى ساين اب ما يتحول الوزرنيم الى باسوورد
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email should not be empty";
                            } else if (!_isValidEmail(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userEmail = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              InputDecoration(labelText: "Email address"),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        // if (widget.isLoeading) CircularProgressIndicator(),
                        //if (!widget.isLoeading)
                        RaisedButton(
                          child: Text("Send Request"),
                          onPressed: _trySendRequest,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
