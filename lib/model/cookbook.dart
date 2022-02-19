import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// test
class Cookbook {
  String? id;
  // final String cookbookName;// the ID is the same is the title that's why we remove the cookbook name
  String? imageURLCookbook;
  DateTime? cookbookTimestamp;

  Cookbook({
    this.id,
    this.imageURLCookbook,
    this.cookbookTimestamp,
  });

  Cookbook.formJson(Map<String, dynamic> json) {
    id = json["cookbook_id"];
    imageURLCookbook = json["cookbook_img_url"];
    cookbookTimestamp = json["timestamp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["cookbook_id"] = this.id;
    data["cookbook_img_url"] = this.imageURLCookbook;
    data["timestamp"] = this.cookbookTimestamp;

    return data;
  }
}
