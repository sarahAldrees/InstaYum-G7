import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class userinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkResponse(
              child: Container(
                margin: EdgeInsets.only(left: 7),
                width: 45,
                height: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://www.eatthis.com/wp-content/uploads/sites/4/2019/11/whole-grain-pancake-stack.jpg?fit=1200%2C879&ssl=1'))),
              ),
              onTap: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Lama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
