import 'package:flutter/material.dart';

class CommentObj {
  String username = "";
  String commentImgUrl = "";
  String comment = "";
  String date;
  String commentRef;
  CommentObj({
    @required this.username,
    @required this.commentImgUrl,
    @required this.comment,
    @required this.date,
    @required this.commentRef,
  });
}
