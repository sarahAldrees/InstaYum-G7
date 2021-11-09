import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestPassword extends StatefulWidget {
  @override
  _RestPasswordState createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _userEmail = "";

  bool _isValidEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(email);
  }

  void _trySendRequest() {
    _formKey.currentState.save();

    final isValidForm = _formKey.currentState.validate();

    bool _switchToLogin = false;
    if (isValidForm) {
      try {
        _auth.sendPasswordResetEmail(email: _userEmail);
        _switchToLogin = true;
      } on PlatformException catch (err) {
        _switchToLogin = false;
        if (err.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("The email or password is incorrect try again!"),
                backgroundColor: Theme.of(context).errorColor),
          );
        }
      } catch (err) {
        _switchToLogin = false;
        print("hehehehe@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(err.code);
      }
    }
    if (_switchToLogin) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          //   Card(),
          // Padding(padding: EdgeInsets.only(top: 100)),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
