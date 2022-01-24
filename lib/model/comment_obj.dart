import 'package:flutter/material.dart';

class CommentObj {
  String username = "";
  String userId = "";
  String commentImgUrl = "";
  String comment = "";
  String date;
  String commentRef;

  CommentObj({
    @required this.username,
    @required this.userId,
    @required this.commentImgUrl,
    @required this.comment,
    @required this.date,
    @required this.commentRef,
  });
}
