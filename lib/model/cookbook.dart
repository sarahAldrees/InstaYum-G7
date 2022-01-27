import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// test
class Cookbook {
  final String id;

  // final String cookbookName;// the ID is the same is the title that's why we remove the cookbook name
  final String imageURLCookbook;

  Cookbook({
    @required this.id,
    @required this.imageURLCookbook,
  });
}
