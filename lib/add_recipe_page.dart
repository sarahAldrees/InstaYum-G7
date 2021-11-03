import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

//import 'dynamic_fields.dart';
class addRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => addRecipe();
}

class addRecipe extends State<addRecipePage> {
  //var dropdownValue;
  bool isSwitched = false;
  //-----------------------list componint of dropdown list-----------------
  var recipeType = ['Breakfast', 'Lunch', 'Dinner'];
  var cuisine = [
    'Asian',
    'Indian',
    'Gulf',
    'Italian',
    'American',
    'Mexican',
    'French',
    'Brazilian',
    'Turki',
    'Egypt',
    'Lebanese'
  ];
  var categoryricpe = [
    'Main course',
    'Soups',
    'Salads',
    'Desserts',
    'Drinks',
    'Appetizers'
  ];
  var cusinurentSelectedValue = 'Asian';
  var CategorycurentSelectedValue = 'Main course';
  var curentSelectedValue = 'Lunch';
  //-----------------------------------
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //---------------add photo-------------
        Container(
          // child: Stack(children: <Widget>[
          //child: Center(
          //child: Container(
          // decoration: BoxDecoration(
          //   border: Border.only(
          //       color: Color(
          //     0xFFeb6d44,
          //   )),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(5.0),
          //   ),
          // ),

          //margin: EdgeInsets.only(top: 30, bottom: 15, left: 10, right: 50),
          // margin: EdgeInsets.only(
          //   left: 5,
          // ),

          width: 50,
          height: 80,
          alignment: Alignment.center,
          //color: Colors.grey,
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_a_photo, size: 30),
            label: Text(
              "add recipe photo",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Color(0xFFeb6d44)),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
              padding: EdgeInsets.only(bottom: 10, top: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFeb6d44), width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                child: ListView(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Flexible(
                            fit: FlexFit.loose,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Add more ingredient'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFeb6d44)),
                              ),
                            )),
                        // OutlinedButton(
                        //     onPressed: () {},
                        //     child: Text("add more ingredient"),
                        //     style: ButtonStyle(
                        //       foregroundColor:
                        //           MaterialStateProperty.all(Color(0xFFeb6d44)),
                        //     )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 20,
                top: 5,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),

                  //color: Colors.white,
                  child: Text(
                    "Ingredients",
                    style: TextStyle(
                      backgroundColor: Colors.grey[50],
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                )),
          ],
        ),
        //------------------direction-------------------------
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
              padding: EdgeInsets.only(bottom: 10, top: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFeb6d44), width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                child: ListView(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFeb6d44), width: 2),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Flexible(
                            fit: FlexFit.loose,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Add more direction'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFeb6d44)),
                              ),
                            )),
                        // OutlinedButton(
                        //     onPressed: () {},
                        //     child: Text("add more ingredient"),
                        //     style: ButtonStyle(
                        //       foregroundColor:
                        //           MaterialStateProperty.all(Color(0xFFeb6d44)),
                        //     )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 20,
                top: 5,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),

                  //color: Colors.white,
                  child: Text(
                    "Direction",
                    style: TextStyle(
                      backgroundColor: Colors.grey[50],
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                )),
          ],
        ),
        //-------------last dirction -----------------
        //------------------classification ---------------------
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.fromLTRB(10, 15, 30, 10),
              padding: EdgeInsets.only(bottom: 10, top: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFeb6d44), width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: ListView(
                children: [
                  //------1--------------
                  Text("     Type of meal:"),
                  Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: curentSelectedValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[700],
                      ),
                      iconSize: 30,
                      underline: Container(
                        height: 1,
                        color: Colors.grey[700],
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          curentSelectedValue = newValue;
                        });
                      },
                      style: const TextStyle(color: Color(0xFFeb6d44)),
                      selectedItemBuilder: (BuildContext context) {
                        return recipeType.map((String value) {
                          return Text(
                            curentSelectedValue,
                            style: const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                      items: recipeType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  //----dropdown--2--------
                  Text("     Category:"),
                  Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: CategorycurentSelectedValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[700],
                      ),
                      iconSize: 30,
                      underline: Container(
                        height: 1,
                        color: Colors.grey[700],
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          CategorycurentSelectedValue = newValue;
                        });
                      },
                      style: const TextStyle(color: Color(0xFFeb6d44)),
                      selectedItemBuilder: (BuildContext context) {
                        return categoryricpe.map((String value) {
                          return Text(
                            CategorycurentSelectedValue,
                            style: const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                      items: categoryricpe
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  //---------------3------------------
                  Text("     Cuisine:"),
                  Container(
                    margin: EdgeInsets.only(bottom: 15, left: 50, right: 50),
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: cusinurentSelectedValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[700],
                      ),
                      iconSize: 30,
                      underline: Container(
                        height: 1,
                        color: Colors.grey[700],
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          cusinurentSelectedValue = newValue;
                        });
                      },
                      style: const TextStyle(color: Color(0xFFeb6d44)),
                      selectedItemBuilder: (BuildContext context) {
                        return cuisine.map((String value) {
                          return Text(
                            cusinurentSelectedValue,
                            style: const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                      items:
                          cuisine.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  //--------------------------------------
                  Container(
                    child: Row(
                      children: [
                        Text("      Praivet"),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              //print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.orange[600],
                          activeColor: Color(0xFFeb6d44),
                        ),
                        Text("      Public"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: 20,
                top: 5,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),

                  //color: Colors.white,
                  child: Text(
                    "Classifications",
                    style: TextStyle(
                      backgroundColor: Colors.grey[50],
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                )),
          ],
        ),

        Align(
            alignment: Alignment.bottomCenter,
            //child: Flexible(
            //fit: FlexFit.loose,
            child: Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Add recipe'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFeb6d44)),
                ),
              ),
            )
            //),
            ),
      ],
    ));
  }
}
