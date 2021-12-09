import 'package:flutter/material.dart';
import 'package:instayum1/screen/my_recipes_screen.dart';
import 'package:flutter/cupertino.dart';
import 'screen/my_recipes_screen.dart';

//import 'package:flutter/material.dart';

class discoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => discover();
}

class discover extends State<discoverPage> {
  bool value = false;
  //final cookingEnthusist = UserPreferences.myCooking_Enthusiast;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 30),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[800],
                ),
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: Colors.grey[800],
                  //fontSize: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFeb6d44),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   height: 600,
          //   child:,// my_recipes(),
          //   padding: EdgeInsets.only(top: 20),
          // ),
        ],
      ),
    );
  }
}
