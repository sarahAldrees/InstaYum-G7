import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/bookmark/bookmarks_recipes_screen.dart';

class cookbook_item extends StatefulWidget {
  @override
  State<cookbook_item> createState() => cookbook_itemState();
  final String cookbookID;
  // final String cookbookName;

  final String imageURLCookbook;
  static bool isBrowse = true;
  Color colorOfCircule = Colors.grey.shade300;
  bool isSlected = false;
  static List<String> slectedCookbooks = [];

  // final VoidCallback onClicked;

  cookbook_item(
    // Key key,
    this.cookbookID,
    // this.cookbookName,
    this.imageURLCookbook,
  );
}

class cookbook_itemState extends State<cookbook_item> {
  int length = bookmarked_recipesState.Cookbooks_List.length;

  @override
  Widget build(BuildContext context) {
    // if (!cookbook_item.slectedCookbooks.isEmpty) {
    //   cookbook_item.slectedCookbooks.clear();
    // }
    for (int i = 0; i < length; i++) {}
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
            color: widget.colorOfCircule,
          ),
          // ignore: deprecated_member_use
          child: FlatButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              int i = 0;
              // for (i; i < length; i++) {
              //   if (bookmarked_recipesState.Cookbooks_List[i].id ==
              //       widget.cookbookID) {
              //         bookmarked_recipesState.Cookbooks_List[i].colorOfCircule=Colors.red;
              //       cookbook_item.colorOfCircule=bookmarked_recipesState.Cookbooks_List[i].colorOfCircule;
              //       break;}
              // }

              if (!cookbook_item.isBrowse) {
                // debugPrint('add to cookbook');
                setState(() {
                  widget.isSlected = !widget.isSlected;
                  if (widget.isSlected)
                    widget.colorOfCircule = Colors.red;
                  else
                    widget.colorOfCircule = Colors.grey.shade300;
                });
                if (widget.isSlected) {
                  cookbook_item.slectedCookbooks.add(widget.cookbookID);
                } else {
                  for (int i = 0;
                      i < cookbook_item.slectedCookbooks.length;
                      i++) {
                    if (cookbook_item.slectedCookbooks[i] == widget.cookbookID)
                      cookbook_item.slectedCookbooks.removeAt(i);
                  }
                }
                print("/////////------------");
                for (int i = 0;
                    i < cookbook_item.slectedCookbooks.length;
                    i++) {
                  print(cookbook_item.slectedCookbooks[i]);
                }
                //print(widget.cookbookID);
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
