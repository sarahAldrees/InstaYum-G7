import 'package:flutter/material.dart';
import 'package:instayum1/main_pages.dart';
import 'package:instayum1/widget/discover/recipe_card.dart';
import 'package:instayum1/widget/meal_plan/meal_title.dart';
import 'package:instayum1/widget/profile/profile.dart';
import 'package:instayum1/widget/recipe_view/recipe_view.dart';

import 'dialog_flow.dart';
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
  String finalText = '';
  final image = AssetImage("assets/images/defaultRecipeImage.png");

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
      if (RecipeCardScreenState.numberOfRecipes == 0)
        finalText = "There are no suitable recipes";
      else
        finalText = "The above are the suggested recipes";
      return <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RecipeCardScreen(),
          Row(
            children: [
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //            Text(this.name,
                    //                style: TextStyle(fontWeight: FontWeight.bold)),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(finalText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ])
      ];
    }
  }

  final userImage = ProfileState.imageURL == "noImage" ||
          ProfileState.imageURL.isEmpty ||
          ProfileState.imageURL == null
      ? AssetImage("assets/images/defaultUser.png") // NEW
      : NetworkImage(ProfileState.imageURL);

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
          child: ClipOval(
            child: Material(
              color: Colors.grey.shade400,
              child: Ink.image(
                image: userImage,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
          ),

          // Image.asset(ProfileState.imageURL
          //     //   'assets/images/defalut_image_chatbot.jpg', // change the image to be the same as the user image (IMPORTANT)
          //     ),
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
