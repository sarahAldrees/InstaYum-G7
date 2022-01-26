import 'package:flutter/material.dart';
import 'package:instayum1/main_pages.dart';
import 'package:instayum1/widget/discover/recipe_card.dart';
import 'package:instayum1/widget/meal_plan/meal_title.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';

import 'recipe_card_screen.dart';

class Messages extends StatefulWidget {
  Messages({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final List<String> ingredients = ["milk"];

  final List<String> dirctions = ["1"];

  final List<String> dircimageUrlst = [
    "  https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43"
  ];

  final image = AssetImage("assets/images/defaultRecipeImage.png");

  List<List<String>> mealInformation = [
    ["hello", "Hello"],
    ["Lunch", "Hello"],
    ["hello", "Hello"]
  ];

  List<Widget> botMessage(context) {
    // bring_recipes is a word saved in dialogflow that indicate we need to represent the resipes
    if (widget.text != "bring_recipes") {
      return <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: CircleAvatar(
            child:
                // Padding(
                //   padding: const EdgeInsets.all(5),
                //child:
                Image.asset('assets/images/InstaYum_chatbot.png'),
            // ),
            backgroundColor: Colors.white,
            radius: 30,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//            Text(this.name,
//                style: TextStyle(fontWeight: FontWeight.bold)),
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text,
                    ),
                  )),
            ],
          ),
        ),
      ];
    } else {
      return <Widget>[
        Column(children: [
          // HomeOfD(),
          RecipeCardScreen(),
          // Card(
          //   child: Container(
          //     height: 90,
          //     width: 330,
          //     child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(left: 2.0),
          //             child: Text(
          //               "Keto diet plan",
          //               style: TextStyle(fontSize: 17, color: Colors.white),
          //             ),
          //           ),
          //           ElevatedButton(
          //             child: Text("Make it my current plan"),
          //             style: ElevatedButton.styleFrom(
          //               onPrimary: Colors.white,
          //               primary: Color(0xFFeb6d44),
          //             ),
          //             onPressed: () {
          //               // Navigator.push(
          //               //   context,
          //               //   MaterialPageRoute(builder: (context) => MainPages()),
          //               // );
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) => HomeOfD()));
          //             },
          //           ),
          //         ]),
          //   ),
          //   // change z-axis place of card
          //   elevation: 3,
          //   shadowColor: Colors.black,
          //   margin: EdgeInsets.all(20),
          //   shape: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide(color: Colors.white)),
          //   color: Colors.orangeAccent,
          // ),
          // Card(
          //   child: Container(
          //     height: 90,
          //     width: 330,
          //     child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(left: 2.0),
          //             child: Text(
          //               "Keto diet plan",
          //               style: TextStyle(fontSize: 17, color: Colors.white),
          //             ),
          //           ),
          //           ElevatedButton(
          //             child: Text("Make it my current plan"),
          //             style: ElevatedButton.styleFrom(
          //               onPrimary: Colors.white,
          //               primary: Color(0xFFeb6d44),
          //             ),
          //             onPressed: () {
          //               // Navigator.push(
          //               //   context,
          //               //   MaterialPageRoute(builder: (context) => MainPages()),
          //               // );
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) => HomeOfD()));
          //               //
          //               //
          //               //
          //               // RecipeView(
          //               //     //key,
          //               //     // autherName,
          //               //     // autherImage,
          //               //     "EiND3Sc8zCQginID4aTvVFwHE7n2",
          //               //     "01f93d17-e5a1-4f0f-b8ba-ab985dc5a305",
          //               //     "recipeName",
          //               //     "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43",
          //               //     "Breakfast",
          //               //     "Appetizers",
          //               //     "American",
          //               //     ingredients,
          //               //     dirctions,
          //               //     dircimageUrlst)));
          //             },
          //           ),
          //         ]),
          //   ),
          //   // change z-axis place of card
          //   elevation: 3,
          //   shadowColor: Colors.black,
          //   margin: EdgeInsets.all(20),
          //   shape: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide(color: Colors.white)),
          //   color: Colors.orangeAccent,
          // )
        ])
      ];
    }
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
//            Text(this.name, style: Theme.of(context).textTheme.subhead),
            Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(color: Colors.black),
                  ),
                )),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          child: Image.asset(
            'assets/images/defalut_image_chatbot.jpg', // change the image to be the same as the user image (IMPORTANT)
          ),
          backgroundColor: Colors.grey[200],
          radius: 25,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.widget.type ? userMessage(context) : botMessage(context),
      ),
    );
  }
}
