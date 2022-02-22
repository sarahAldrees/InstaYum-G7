import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// test
class Cookbook {
  String? id;
  // final String cookbookName;// the ID is the same is the title that's why we remove the cookbook name
  String? imageURLCookbook;
  Timestamp? cookbookTimestamp;
  List<dynamic>? bookmarkedList;

  Cookbook(
      {this.id,
      this.imageURLCookbook,
      this.cookbookTimestamp,
      this.bookmarkedList});

  Cookbook.fromJson(Map<String, dynamic> json) {
    id = json["cookbook_id"];
    imageURLCookbook = json["cookbook_img_url"];
    cookbookTimestamp = json["timestamp"];
    bookmarkedList = json["bookmarkedList"];
  }

  Map<String, dynamic> toJson() {
    print("TTTTTTTTOOOOOOOOOOOOOOO JISON");
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["cookbook_id"] = this.id;
    data["cookbook_img_url"] = this.imageURLCookbook;
    data["timestamp"] = this.cookbookTimestamp;
    data["bookmarkedList"] = this.bookmarkedList;

    return data;
  }
}
