import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/widget/profile/profile.dart';
import 'package:intl/intl.dart';
import 'recipe_card_screen.dart';

class Messages extends StatefulWidget {
  Messages({this.text, this.name, this.type});

  final String? text;
  final String? name;
  final bool? type;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final image = AssetImage("assets/images/defaultRecipeImage.png");

  List<Widget> botMessage(context) {
    // bring_recipes is a word saved in dialogflow that indicate we need to represent the resipes
    if (widget.text == "bring_recipes") {
      return <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RecipeCardScreen(),
        ])
      ];
    } else if (widget.text == "Can i have more recipes") {
      return <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RecipeCardScreen(),
        ])
      ];
    } else {
      return <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: CircleAvatar(
            child: Image.asset('assets/images/InstaYum_chatbot.png'),
            backgroundColor: Colors.white,
            radius: 30,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text!,
                    ),
                  )),
            ],
          ),
        ),
      ];
    }
  }

  final userImage = AppGlobals.userImage == "noImage" ||
          AppGlobals.userImage!.isEmpty ||
          AppGlobals.userImage == null
      ? AssetImage("assets/images/defaultUser.png")
      : NetworkImage(AppGlobals.userImage!);

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text!,
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
                image: userImage as ImageProvider<Object>,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
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
        children:
            this.widget.type! ? userMessage(context) : botMessage(context),
      ),
    );
  }
}
