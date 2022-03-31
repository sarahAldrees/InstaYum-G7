// import 'package:flutter/material.dart';

// class ReprtedComment {
//   String username = "";
//   String userId = "";
//   String commentImgUrl = "";
//   String comment = "";
//   String date;
//   String commentRef;
//   String reason;
//   int no_reports;

//   ReprtedComment({
//     @required this.username,
//     @required this.userId,
//     @required this.commentImgUrl,
//     @required this.comment,
//     @required this.date,
//     @required this.commentRef,
//     @required this.reason,
//     @required this.no_reports,
//   });
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReprtedComment {
  String? commentRef;
  String? commentOwner;
  String? recipeId;
  String? commentDate;
  String? commentText;
  int? bullying;
  int? fraudulent;
  int? unethical;
  int? IDontLike;
  int? no_reports;
  List<String>? user_already_reported;
  ReprtedComment({
    this.commentRef,
    this.commentOwner,
    this.recipeId,
    this.commentDate,
    this.commentText,
    this.bullying,
    this.fraudulent,
    this.unethical,
    this.IDontLike,
    this.no_reports,
    this.user_already_reported,
  });

  ReprtedComment.fromJson(Map<String, dynamic> json) {
    commentRef = json['commentRef'];
    commentOwner = json['commentOwner'];
    recipeId = json['recipeId'];
    commentDate = json['commentDate'];
    commentText = json['commentText'];
    bullying = json['bullying'];
    fraudulent = json['fraudulent'];
    unethical = json['unethical'];
    IDontLike = json['IDontLike'];
    no_reports = json['no_reports'];
    user_already_reported = json['user_already_reported'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentRef'] = this.commentRef;
    data['commentOwner'] = this.commentOwner;
    data['recipeId'] = this.recipeId;
    data['commentDate'] = this.commentDate;
    data['commentText'] = this.commentText;
    data['bullying'] = this.bullying;
    data['fraudulent'] = this.fraudulent;
    data['unethical'] = this.unethical;
    data['IDontLike'] = this.IDontLike;
    data['no_reports'] = this.no_reports;
    data['user_already_reported'] = this.user_already_reported;
    return data;
  }
}
