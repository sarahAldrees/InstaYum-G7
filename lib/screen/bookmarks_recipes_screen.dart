import 'package:flutter/material.dart';
import 'package:instayum1/data.dart';

import 'package:instayum1/widget/cookbook_item.dart';

class bookmarked_recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // remove the default default flutter banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // build the button to add a new cookbook
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFeb6d44),
            onPressed: () {},
            child: Icon(Icons.add),
          ),
          // here the list of grid view
          body: GridView.count(
            crossAxisCount: 2, // 2 items in each row
            padding: EdgeInsets.all(25),
            // map all available cookbooks and list them in Gridviwe.
            children: Cookbook_Data.map((c) => cookbook_item(
                  key,
                  c.id,
                  c.cookbookName,
                  c.imageURLCookbook,
                )).toList(),
          )),
    );
    // ]);
  }
}
