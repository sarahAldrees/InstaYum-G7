import 'package:flutter/material.dart';
import 'package:instayum1/screen/my_recipes_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:instayum1/utils/user_preferences.dart';
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
      // body: GridView(
      //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //       maxCrossAxisExtent: 600,
      //       childAspectRatio: 1 / 2,
      //       crossAxisSpacing: 20,
      //     ),
      //     children: <Widget>[
      // body: Stack(
      //   children: <Widget>[
      //     Container(
      //       width: double.infinity,
      //       height: 200,
      //       margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      //       padding: EdgeInsets.only(bottom: 10, top: 15),
      //       decoration: BoxDecoration(
      //         border: Border.all(color: Color(0xFFeb6d44), width: 1),
      //         borderRadius: BorderRadius.circular(5),
      //         shape: BoxShape.rectangle,
      //       ),
      //       child: Container(
      //         margin: EdgeInsets.only(
      //           bottom: 15,
      //           left: 50,
      //         ),
      //         // child: ListView(
      //         //children: [
      //         child: Container(
      //           alignment: Alignment.centerLeft,
      //           height: 200,
      //           child: my_recipes(),
      //           //padding: EdgeInsets.only(top: 20),
      //         ),
      //         //   ],
      //         // ),
      //       ),
      //     ),
      //     Positioned(
      //         left: 25,
      //         top: 5,
      //         child: Container(
      //           padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),

      //           //color: Colors.white,
      //           child: Text(
      //             "Recommended recipes ",
      //             style: TextStyle(
      //               backgroundColor: Colors.grey[50],
      //               fontSize: 17,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey[700],
      //             ),
      //           ),
      //         )),
      //   ],
      // ),
      //------------
      body: Container(
        height: 600,
        child: my_recipes(),
        padding: EdgeInsets.only(top: 20),
      ),

      //------------
      // ]
      // ),

      //Padding(
      //     // padding: EdgeInsets.symmetric(
      //     //     vertical: double.infinity, horizontal: double.maxFinite),
      //     // child:
      //     Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [

      //     Container(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           Text("Recommended recipes"),

      // Container(
      // child: GridView(
      //   children: <Widget>[],
      //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //     maxCrossAxisExtent: 200,
      //     childAspectRatio: 3 / 2,
      //     crossAxisSpacing: 20,
      //   ),
      //           // ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //     Image(
      //       image: AssetImage("assets/images/HLine.png"),
      //       width: double.infinity,
      //     )
      //   ],
      // ),
      // //),
      // //     body: Column(
      // //   children: [
      // //     //-----------------------------recomended-----------

      // //     Container(
      // //       child: GridView(
      // //         children: <Widget>[],
      // //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      // //           maxCrossAxisExtent: 200,
      // //           childAspectRatio: 3 / 2,
      // //           crossAxisSpacing: 20,
      // //         ),
      // //       ),
      // //     ),
      // //     // Padding(
      // //     //   padding: EdgeInsets.symmetric(horizontal: 10.0),
      // //     //   child: Container(
      // //     //     height: 1.0,
      // //     //     width: 130.0,
      // //     //     color: Colors.black,
      // //     //   ),
      // //     // ),
      // //     Image.asset("assets/images/HLine.png"),
      // //     //-----------------------------who i fowllwe------------
      // //     Container(
      // //       child: GridView(
      // //         children: <Widget>[],
      // //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      // //           maxCrossAxisExtent: 200,
      //           childAspectRatio: 3 / 2,
      //           crossAxisSpacing: 20,
      //         ),
      //       ),
      //     ),
      //   ],
      // )
      //
    );
  }
}
