import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:instayum/main.dart';
import 'package:instayum/model/notification_model.dart';

import 'package:instayum/widget/profile/user_profile_view.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // late final FirebaseMessaging _messaging;
  // PushNotification? messageData;
  PushNotification notification = new PushNotification();

  Future<void> registerNotification() async {
    try {
      // 1. Initialize the Firebase app
      // await Firebase.initializeApp(); // added in main

      // 2. Instantiate Firebase Messaging
      // _messaging = FirebaseMessaging.instance;

      // 3. On iOS, this helps to take the user permissions
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      await enableIOSNotifications();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');

        getPushToken();

        checkForInitialMessage();

        // For handling the received notifications inApp
        FirebaseMessaging.onMessage.listen(
          (RemoteMessage? message) {
            print("onMessage: ${message}");
            if (message != null) {
              print("onMessage: ${message.notification}");
              print("message data: ${message.data}");
              // print("onMessage: $message");

              NotificationModel? messageData;
              Map<String, dynamic> parsedMessage;

              // Parse the received notfication data
              parsedMessage = message.data;

              if (message.notification != null) {
                notification = PushNotification(
                  title: message.notification!.title,
                  body: message.notification!.body,
                  dataTitle: message.data['title1'],
                  dataBody: message.data['body'],
                );
              }

              print("parsedMessage: $parsedMessage");
              messageData = NotificationModel.fromJson(parsedMessage);
              String msgString =
                  "${messageData.body ?? notification.body ?? ''}";

              if (messageData != null) {
                print('in app notif data: $msgString');
                // For displaying the notification as an overlay
                showSimpleNotification(
                  GestureDetector(
                    child: Text(
                      msgString,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      notificationNavigation(messageData);
                    },
                  ),
                  slideDismissDirection: DismissDirection.up,
                  background: Colors.green,
                  duration: Duration(seconds: 3),
                );
              }
            }
          },
        );

        // For handling notification when the app in background
        // but not terminated
        FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage? message) {
            print('Message clicked onMessageOpenedApp! ${message}');

            if (message != null) {
              print("onMessageOpenedApp: ${message.notification}");
              print("message data: ${message.data}");
              // print("onMessage: $message");

              NotificationModel? messageData;
              Map<String, dynamic> parsedMessage;

              // Parse the received notfication data
              parsedMessage = message.data;

              if (message.notification != null) {
                notification = PushNotification(
                  title: message.notification!.title,
                  body: message.notification!.body,
                  dataTitle: message.data['title1'],
                  dataBody: message.data['body'],
                );
              }

              print("parsedMessage: $parsedMessage");
              messageData = NotificationModel.fromJson(parsedMessage);
              String msgString =
                  "${messageData.body ?? notification.body ?? ''}";
              print('bg app notif data: $msgString');

              notificationNavigation(messageData);
            }
          },
        );

        // For handling notification when the app is
        //in the background or terminated.
        // FirebaseMessaging.onBackgroundMessage(
        //   (message) => firebaseMessagingBackgroundHandler(message),
        // );
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print("in registerNotification error $e");
    }
  }

  // For handling notification when the app is
  //in Terminated state
  checkForInitialMessage() async {
    // await Firebase.initializeApp();
    RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      print('initial notif data: ${message.data}');

      NotificationModel? messageData;
      Map<String, dynamic> parsedMessage;

      // Parse the received notfication data
      parsedMessage = message.data;

      if (message.notification != null) {
        notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title1'],
          dataBody: message.data['body'],
        );
      }

      print("parsedMessage: $parsedMessage");
      messageData = NotificationModel.fromJson(parsedMessage);
      String msgString = "${messageData.body ?? notification.body ?? ''}";
      print('bg app notif data: $msgString');

      notificationNavigation(messageData);
    }
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<String?> getPushToken() async {
    try {
      String? fcmToken = await firebaseMessaging.getToken();
      print('fcmToken: $fcmToken');
      return fcmToken;
    } catch (e) {
      print('getPushToken error: $e');
      return null;
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: $message");
  print('background message ${message.notification?.body}');

  NotificationModel? messageData;
  PushNotification? notification;
  Map<String, dynamic> parsedMessage;

  // Parse the received notfication data
  parsedMessage = message.data;

  if (message.notification != null) {
    notification = PushNotification(
      title: message.notification!.title,
      body: message.notification!.body,
      dataTitle: message.data['title1'],
      dataBody: message.data['body'],
    );
  }

  print("parsedMessage: $parsedMessage");
  messageData = NotificationModel.fromJson(parsedMessage);
  String msgString = "${messageData.body ?? notification?.body ?? ''}";
  print('bgs app notif data: $msgString');

  notificationNavigation(messageData);
}

// check and handle condition for navigation
void notificationNavigation(NotificationModel? messageData) {
  if (messageData != null) {
    if (messageData.type == 'follow') {
      //navigate to user profile page
      navigatorKey.currentState!.push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            UserProfileView(userId: messageData.userId),
      ));
    } else {
      //navigate to view recipe page
      if (messageData.recipeId != null) {
        navigatorKey.currentState!.push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              RecipeView(recipeid: messageData.recipeId),
        ));
      }
    }
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
