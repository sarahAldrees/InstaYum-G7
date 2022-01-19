import 'package:flutter/material.dart';

class FollowersNumbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          buildButton(context, '0', 'Following'),
          buildDivider(),
          buildButton(context, '0', 'Followers'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child:
            //-----------------
            Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(fontSize: 20),
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
