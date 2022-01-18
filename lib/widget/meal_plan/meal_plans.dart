import 'package:flutter/material.dart';

class MealPlans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MealPlansState();
}

class MealPlansState extends State<MealPlans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFeb6d44),
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('DAY')),
                  DataColumn(
                      label: Text(
                    'Breakfast',
                  )),
                  DataColumn(label: Text('Lunch')),
                  DataColumn(label: Text('Dinner'))
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('sat')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('sun')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('mun')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('tus')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('wed')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('thu')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('fri')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ]),
                ],
              ),
            ),
          )
        ]));
  }
}
