import 'package:flutter/material.dart';

class FollowersNumbers extends StatefulWidget {
  FollowersNumbers({Key? key, this.userId}) : super(key: key);
  String? userId;

  @override
  State<FollowersNumbers> createState() => _FollowersNumbersState();
}

class _FollowersNumbersState extends State<FollowersNumbers> {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          buildDivider(),
          buildButton(context, '0', 'Following'),
          buildButton(context, '0', 'Followers'),
        ],
      );
  Widget buildDivider() => Container(
        height: 3,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 0),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child:
            //-----------------
            Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(fontSize: 15),
              ),
              //------------------------
              SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
