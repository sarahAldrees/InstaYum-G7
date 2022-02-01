import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/bookmark/bookmarks_recipes_screen.dart';
import 'package:instayum1/widget/bookmark/cookbook_recipes.dart';

class CookbookItem extends StatefulWidget {
  @override
  State<CookbookItem> createState() => CookbookItemState();
  final String cookbookID;
  // final String cookbookName;

  final String imageURLCookbook;
  static bool isBrowse = true;

  Color colorOfCircule = Colors.grey.shade300;
  bool isSelected = false;
  static List<String> slectedCookbooks = [];

  // final VoidCallback onClicked;

  CookbookItem(
    // Key key,
    this.cookbookID,
    // this.cookbookName,
    this.imageURLCookbook,
  );
}

class CookbookItemState extends State<CookbookItem> {
  int length = BookmarkedRecipesState.Cookbooks_List.length;

  @override
  Widget build(BuildContext context) {
    // if (!cookbook_item.slectedCookbooks.isEmpty) {
    //   cookbook_item.slectedCookbooks.clear();
    // }
    for (int i = 0; i < length; i++) {}
    final image = widget.imageURLCookbook == "noImage"
        ? AssetImage("assets/images/defaultCookbookImage.png")
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
              if (!CookbookItem.isBrowse) {
                // debugPrint('add to cookbook');
                setState(() {
                  widget.isSelected = !widget.isSelected;
                  if (widget.isSelected)
                    widget.colorOfCircule = Colors.red;
                  else
                    widget.colorOfCircule = Colors.grey.shade300;
                });
                if (widget.isSelected) {
                  CookbookItem.slectedCookbooks.add(widget.cookbookID);
                } else {
                  for (int i = 0;
                      i < CookbookItem.slectedCookbooks.length;
                      i++) {
                    if (CookbookItem.slectedCookbooks[i] == widget.cookbookID)
                      CookbookItem.slectedCookbooks.removeAt(i);
                  }
                }
                print("/////////------------");
                for (int i = 0; i < CookbookItem.slectedCookbooks.length; i++) {
                  print(CookbookItem.slectedCookbooks[i]);
                }
                //print(widget.cookbookID);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CookbookRecipes(widget.cookbookID)));

//-------------------------------------------------------

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
