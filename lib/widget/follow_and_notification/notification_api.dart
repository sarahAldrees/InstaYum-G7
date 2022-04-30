import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:instayum/main_pages.dart';
import 'package:instayum/model/notification_model.dart';

class NotificationApi {
  static Future<void> SendNotification({
    String? title1,
    String? title2,
    String? body,
    String? desc,
    String? userId,
    String? recipeId,
    String? otherUserId,
    String? type,
    String? name,
    String? token,
    String? imageUrl,
    Timestamp? timestamp,
  }) async {
    // create data for notification body
    NotificationModel notification = NotificationModel(
      type: type,
      title1: title1,
      title2: title2,
      description: desc,
      body: body,
      recipeId: recipeId,
      userId: userId,
      userName: name,
      userImage: imageUrl,
      // date: timestamp,
    );

    // Replace with server token from firebase console settings.
    // increase the notification count for other user
    increaseNotificationCount(otherUserId);

    await http
        .post(Uri.parse(
                //direct all HTTP requests to this endpoint
                'https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAAEvcRJBU:APA91bFrkBq7j9veKQbxLDFiSLkAV-t4VwP-IktWwiagJVaDk295-HomB-_M4uLzLXjUc65yp8tj7Oh5_EBfh6f9YHIq8qy7gL3VsyYLMrSv-2bFxwtItuqP_7OmapAjLvVFRdbtAb18",
            }, // server token from firestore
            body: jsonEncode(
              <dynamic, dynamic>{
                "notification": <String, dynamic>{
                  "body": body,
                  "title": "InstaYum",
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                },
                "to": token,
                "priority": "high",
                "data": notification.toJson(),
              },
            ))
        .then((value) {
      // print('notification sent');
    }).catchError(
      (onError) {
        print("sendNotification Err:  $onError");
        print(onError.message);
      },
    );
  }

  static void increaseNotificationCount(String? userId) {
    print("-----------------------------------------------------");
    print(userId);

    if (userId != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).update(
        {'notificationsCount': FieldValue.increment(1)},
      ); // SetOptions(merge: true));
    }
  }
}
