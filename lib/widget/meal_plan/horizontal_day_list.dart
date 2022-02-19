import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class HorizontalDayList extends StatefulWidget {
  final Function dayUpdateFunction;

  HorizontalDayList(this.dayUpdateFunction);

  @override
  _HorizontalDayListState createState() => _HorizontalDayListState();
}

class _HorizontalDayListState extends State<HorizontalDayList> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      DateTime date = DateTime.now();
      widget.dayUpdateFunction(weekdays[date.weekday - 1]);
      updateDayColor(date.weekday);
    });
  }

  List<String> weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

  Color activeCardColor = Color(0xFFeb6d44);
  Color? inactiveCardColor = Colors.grey[600];

  Color activeTextColor = Colors.white;
  Color inactiveTextColor = Colors.white;

  List<List<Color?>> cardColorList = [
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
    [Colors.grey[600], Colors.white],
  ];
  void updateDayColor(int index) {
    setState(() {
      for (int i = 0; i < cardColorList.length; i++) {
        cardColorList[i][0] = inactiveCardColor;
        cardColorList[i][1] = inactiveTextColor;
      }

      cardColorList[index][0] = activeCardColor;
      cardColorList[index][1] = activeTextColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekdays.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              {
                updateDayColor(index);
                widget.dayUpdateFunction(weekdays[index]);
              }
              setState(() {
                for (int i = 0; i < cardColorList.length; i++) {
                  cardColorList[i][0] = inactiveCardColor;
                  cardColorList[i][1] = inactiveTextColor;
                }

                cardColorList[index][0] = activeCardColor;
                cardColorList[index][1] = activeTextColor;
              });
              widget.dayUpdateFunction(weekdays[index]);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
              height: 60,
              width: 46,
              decoration: BoxDecoration(
                  color: cardColorList[index][0],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    weekdays[index],
                    style: TextStyle(
                        fontSize: 16,
                        color: cardColorList[index][1],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
