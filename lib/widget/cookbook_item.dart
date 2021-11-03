import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cookbook_item extends StatelessWidget {
  final String id;
  final String cookbookName;
  final String imageURLCookbook;
  // final VoidCallback onClicked;

  const cookbook_item(
    Key key,
    this.id,
    this.cookbookName,
    this.imageURLCookbook,
  );

  void selectCookbook() {}
  @override
  Widget build(BuildContext context) {
    final String image = imageURLCookbook;
// this section will return one item of Grid Items that in bookmarked recipes page.
    return Column(children: [
      ClipOval(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
          // ignore: deprecated_member_use
          child: FlatButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              debugPrint('bottun clicked');
            },
            child: ClipOval(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                // cimageURL, fit: BoxFit.cover,
                // Size of the image
                width: 120,
                height: 120,
              ),
            ),
          ),
        ),
      ),
      Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          child: Center(
            child: Text(
              cookbookName,
              style: TextStyle(fontSize: 14),
            ),
          )),
    ]);

    // child: Stack(
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(10),
    //       child: Image.network(imageURLCookbook),
    //     ),
    //     Container(
    //       padding: EdgeInsets.symmetric(vertical: 10),
    //       color: Color(0xff9C635614),
    //       child: Text(cookbookName,
    //           style: TextStyle(fontSize: 15, color: Colors.white)),
    //     ),
    //   ],
    // ),
  }
}
