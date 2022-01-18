import 'package:flutter/material.dart';

class my_meal_plans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // build and return the container which is the Tap veiw of meal Plans
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child:
              // build card of the meal plan name and the button .
              Card(
            child: Container(
              height: 90,
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        "Keto diet plan",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Make it my current plan"),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Color(0xFFeb6d44),
                      ),
                      onPressed: () {},
                    ),
                  ]),
            ),
            // change z-axis place of card
            elevation: 3,
            shadowColor: Colors.black,
            margin: EdgeInsets.all(20),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white)),
            color: Colors.orangeAccent,
          )),
    );
  }
}
