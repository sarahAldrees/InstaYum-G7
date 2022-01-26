import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cookbook_item extends StatefulWidget {
  @override
  State<cookbook_item> createState() => cookbook_itemState();
  final String cookbookID;
  // final String cookbookName;

  final String imageURLCookbook;
  static bool isBrowse = true;
  static Color colorOfCircule = Colors.grey.shade300;

  // final VoidCallback onClicked;

  const cookbook_item(
    // Key key,
    this.cookbookID,
    // this.cookbookName,
    this.imageURLCookbook,
  );
}

class cookbook_itemState extends State<cookbook_item> {
  @override
  Widget build(BuildContext context) {
    final image = widget.imageURLCookbook == "noImage"
        ? AssetImage("assets/images/defaultRecipeImage.png")
        : NetworkImage(widget.imageURLCookbook);
// this section will return one item of Grid Items that in bookmarked recipes page.
    return Column(children: [
      ClipOval(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: cookbook_item.colorOfCircule,
          ),
          // ignore: deprecated_member_use
          child: FlatButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              if (!cookbook_item.isBrowse) {
                debugPrint('add to cookbook');
                setState(() {
                  cookbook_item.colorOfCircule = Colors.red;
                });
                print(widget.cookbookID);
              } else {
                debugPrint('browse');
              }
            },
            child: ClipOval(
              child: Material(
                color: Colors.white,
                child: Ink.image(
                  image: image,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
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
              // cookbookName,
              widget
                  .cookbookID, // the ID is the same is the title that's why we remove the cookbook name
              style: TextStyle(fontSize: 14),
            ),
          )),
    ]);
  }
}
