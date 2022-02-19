import 'package:flutter/material.dart';
import 'package:instayum/widget/meal_plan/horizontal_day_list.dart';

import 'meal_grid_view.dart';

class MealPlans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MealPlansState();
}

class MealPlansState extends State<MealPlans> {
  List<List<String>> mealInformation = [
    ["hello", "Hello"],
    ["Lunch", "Hello"],
    ["hello", "Hello"]
  ];

  String weekday = "SUN";

  void changeWeekday(String newDay) {
    setState(() {
      weekday = newDay;
    });
    print("changed, $weekday");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("Add a new meal plan"),
          backgroundColor: Colors.grey[600],
          //Color(0xFFeb6d44),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            HorizontalDayList(changeWeekday),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                // the white space
                child: MealGridView(
                    mealList:
                        mealInformation), // we call the gird view to present them in the white space
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    boxShadow: [BoxShadow(blurRadius: 10.0)]),
              ),
            ),
          ],
        ));
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       floatingActionButton: FloatingActionButton(
  //         backgroundColor: Color(0xFFeb6d44),
  //         onPressed: () {},
  //         child: Icon(Icons.add),
  //       ),
  //       body: ListView(children: <Widget>[
  //         Container(
  //           padding: EdgeInsets.only(top: 40),
  //           child: Center(
  //             child: DataTable(
  //               columns: [
  //                 DataColumn(label: Text('DAY')),
  //                 DataColumn(
  //                     label: Text(
  //                   'Breakfast',
  //                 )),
  //                 DataColumn(label: Text('Lunch')),
  //                 DataColumn(label: Text('Dinner'))
  //               ],
  //               rows: [
  //                 DataRow(cells: [
  //                   DataCell(Text('sat')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('sun')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('mun')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('tus')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('wed')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('thu')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //                 DataRow(cells: [
  //                   DataCell(Text('fri')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                   DataCell(Text('')),
  //                 ]),
  //               ],
  //             ),
  //           ),
  //         )
  //       ]));
  // }

