import 'package:flutter/material.dart';
import 'package:instayum1/widget/discover/dialog_flow.dart';
import 'package:instayum1/widget/recipe_view/my_recipes_screen.dart';
import 'package:flutter/cupertino.dart';
import '../recipe_view/my_recipes_screen.dart';
import 'chatbot_chat.dart';

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
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Color(0xFFeb6d44),

        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ChatbotChat()));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatBot()));
//FlutterFactsChatBot
          // ChatbotChat();
        },
        child: Image.asset(
          'assets/images/InstaYum_chatbot.png',
          height: 300,
        ),
        //Icon(Icons.support_agent_rounded),
      ),
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
