import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? commentId;
  String? userId;
  String? username;
  String? recipeId;
  String? imageUrl;
  Timestamp? timestamp;
  String? shownDate;
  String? comment;

  CommentModel(
      {this.commentId,
      this.userId,
      this.username,
      this.recipeId,
      this.imageUrl,
      this.timestamp,
      this.shownDate,
      this.comment});

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    userId = json['userId'];
    username = json['username'];
    recipeId = json['recipeId'];
    imageUrl = json['imageUrl'];
    timestamp = json['timestamp'];
    shownDate = json['shownDate'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['recipeId'] = this.recipeId;
    data['imageUrl'] = this.imageUrl;
    data['timestamp'] = this.timestamp;
    data['shownDate'] = this.shownDate;
    data['comment'] = this.comment;
    return data;
  }
}
