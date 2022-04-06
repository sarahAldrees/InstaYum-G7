import 'package:flutter/material.dart';
import 'package:instayum/widget/discover/chatbot/dialog_flow.dart';
import 'package:instayum/widget/recipe_view/my_recipes_screen.dart';
import 'package:flutter/cupertino.dart';
import '../recipe_view/my_recipes_screen.dart';
import 'search/search_page.dart';

//import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Discover();
}

class Discover extends State<DiscoverPage> {
  bool value = false;
  //final cookingEnthusist = UserPreferences.myCooking_Enthusiast;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatBot()));
        },
        child: Image.asset(
          'assets/images/InstaYum_chatbot.png',
          height: 300,
        ),
        //Icon(Icons.support_agent_rounded),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, size: 30),
                    onPressed: () {
                      //Go to search page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(
                              isFromMealPlan: false,
                              mealDay: "",
                              mealPlanTypeOfMeal: "",
                            ),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //: ListView(
      //   children: [
      //     Container(
      //       margin: EdgeInsets.only(top: 10, left: 20, right: 30),
      //       child: TextField(
      //         decoration: InputDecoration(
      //           prefixIcon: Icon(
      //             Icons.search,
      //             color: Colors.grey[800],
      //           ),
      //           labelText: 'Search',
      //           labelStyle: TextStyle(
      //             color: Colors.grey[800],
      //             //fontSize: 16,
      //           ),
      //           enabledBorder: OutlineInputBorder(
      //             borderSide: BorderSide(
      //               color: Colors.grey,
      //             ),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderSide: BorderSide(
      //               color: Color(0xFFeb6d44),
      //               width: 2,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
