import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instayum/constant/app_globals.dart';

class FollowersNumbers extends StatefulWidget {
  FollowersNumbers({Key? key, this.userId}) : super(key: key);
  String? userId;

  @override
  State<FollowersNumbers> createState() => _FollowersNumbersState();
}

class _FollowersNumbersState extends State<FollowersNumbers> {
  List<DocumentSnapshot> followersList = [];
  List<DocumentSnapshot> followingList = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        buildButton(
          context,
          text: 'Following',
          isFollowing: true,
          value: '${followingList.length}',
        ),
        buildDivider(),
        buildButton(
          context,
          text: 'Followers',
          isFollowing: false,
          value: '${followersList.length}',
        ),
      ],
    );
  }

  Widget buildButton(BuildContext context,
          {String? value, String? text, bool isFollowing = false}) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        onPressed: () {
          if (widget.userId == AppGlobals.userId) {}
        },
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
                value ?? '0',
                style: TextStyle(fontSize: 20),
              ),
              //------------------------
              SizedBox(height: 2),
              Text(
                text ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );
}
