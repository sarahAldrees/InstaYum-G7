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
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    print('get user followers and following..');
    // get user followers list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection("followers")
        .get()
        .then((querySnapshot) {
      followersList = querySnapshot.docs;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('following')
        .get()
        .then((querySnapshot) {
      followingList = querySnapshot.docs;
      _saveFollowing(followingList);
    });
    if (mounted) setState(() {});
  }

  _saveFollowing(List<DocumentSnapshot> followings) {
    AppGlobals.allFollowing.clear();
    for (int i = 0; i < followings.length; i++) {
      String id = followings[i].id;
      AppGlobals.allFollowing.add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getData();
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
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          if (widget.userId == AppGlobals.userId) {
            //move to page
          }
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
