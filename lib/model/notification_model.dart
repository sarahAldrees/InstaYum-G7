import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  Timestamp? date;
  String? userId;
  String? recipeId;
  String? userImage;
  String? title1;
  String? title2;
  String? description;
  String? userName;
  String? body;
  String? type; //1=follow, 2=add new recipe, 3=comment on recipe

  NotificationModel({
    this.date,
    this.description,
    this.title1,
    this.title2,
    this.type,
    this.userId,
    this.userImage,
    this.recipeId,
    this.userName,
    this.body,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    description = json['description'];
    title1 = json['title1'];
    title2 = json['title2'];
    type = json['type'];
    userId = json['userId'];
    userImage = json['userImage'];
    recipeId = json['recipeId'];
    userName = json['userName'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['description'] = this.description;
    data['title1'] = this.title1;
    data['title2'] = this.title2;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['userImage'] = this.userImage;
    data['recipeId'] = this.recipeId;
    data['userName'] = this.userName;
    data['body'] = this.body;
    return data;
  }
}
