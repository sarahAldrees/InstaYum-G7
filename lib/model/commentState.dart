import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class commentState {
  String username = "";
  String commentImgUrl = "";
  String comment = "";
  String date;
  commentState({
    @required this.username,
    @required this.commentImgUrl,
    @required this.comment,
    @required this.date,
  });
}
