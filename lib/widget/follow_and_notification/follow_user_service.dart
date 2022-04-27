import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/notification_model.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/follow_and_notification/notification_api.dart';

class FollowUserService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future followUser(BuildContext context, {String? followId}) async {
    try {
      String? email;
      String? username;
      String? imageUrl;
      String? pushToken;

      print('followId: $followId');
      if (followId != null) {
        //------------get info of other user-------------
        DocumentSnapshot docSnapshot =
            await firebaseFirestore.collection('users').doc(followId).get();

        if (docSnapshot != null) {
          print(' followUserData: ${docSnapshot.data()}');
          Map data = docSnapshot.data() as Map<String, dynamic>;
          // email = data['email'];
          username = data['username'];
          imageUrl = data['image_url'];
          pushToken = data['pushToken'];
        }
        UserModel followUser = UserModel(
          //email: email,
          userId: followId,
          username: username,
          imageUrl: imageUrl,
          pushToken: pushToken,
        );

        // ------------Add user info to following list-----------
        firebaseFirestore
            .collection("users")
            .doc(AppGlobals.userId)
            .collection('following')
            .doc(followId)
            .set(followUser.toJson())
            .catchError((error) => print('Following failed: $error'));

        UserModel currentUser = UserModel().getCurrentUserData();

        //-----------check wether other user is in followers list to updat in the followers list----------
        bool isFollower = await checkFollower(currentUser.userId, followId);
        if (isFollower) {
          firebaseFirestore
              .collection("users")
              .doc(AppGlobals.userId)
              .collection("followers")
              .doc(followId)
              .update({"isFollowed": true}).catchError(
                  (error) => print('followers status failed: $error'));
        }

        //------check wether other user is followed or not to updating the following list-----------------
        bool isFollow = await checkFollowing(followId, currentUser.userId);
        currentUser.isFollowed = isFollow;

        // ----------Add user to other user followers list-----------------

        firebaseFirestore
            .collection("users")
            .doc(followId)
            .collection("followers")
            .doc('${currentUser.userId}')
            .set(currentUser.toJson())
            .catchError(
              (error) => print('Followers failed: $error'),
            );

        String name = '${currentUser.username}';
        String desc = 'started following you';
        Timestamp timestamp = Timestamp.now();

        NotificationModel notification = NotificationModel(
          date: timestamp,
          title1: name,
          title2: '',
          description: desc,
          type: 'follow',
          userName: name,
          userId: currentUser.userId,
          userImage: currentUser.imageUrl,
        );

        //--- Add notification to other user notifications list-----
        firebaseFirestore
            .collection('users/$followId/notifications')
            .add(notification.toJson())
            .catchError((error) => print('Notifications failed: $error'));

        //----- Send Notification to other user-------------
        NotificationApi.SendNotification(
          type: 'follow',
          token: pushToken,
          title1: name,
          desc: desc,
          body: '$name $desc',
          timestamp: timestamp,
          otherUserId: followId,
          name: name,
          userId: currentUser.userId,
          imageUrl: currentUser.imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are now following $username'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('FollowUserService : $e');
    }
  }

  // ------to check is 1st user is following 2nd user or not-------

  Future<bool> checkFollowing(String? userId, String? followId) async {
    bool exist = false;
    try {
      await firebaseFirestore
          .collection("users")
          .doc(userId)
          .collection('following')
          .doc("$followId")
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  Future<bool?> unFollowUser(BuildContext context, {String? followId}) async {
    String? userId = AppGlobals.userId;
    try {
      //Remove complete user from my following list
      firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection("following")
          .doc('$followId')
          .delete()
          .catchError((error) => print('Unfollowing failed: $error'));

      //Remove complete user from other user followers list
      firebaseFirestore
          .collection('users')
          .doc(followId)
          .collection('followers')
          .doc('$userId')
          .delete()
          .catchError((error) => print('Unfollowing failed: $error'));
//------------------------------------------------------------------------------
//-----------check wether user is in my followers list to convert status---------------
      bool isFollower = await checkFollower(userId, followId);

      if (isFollower) {
        firebaseFirestore
            .collection('users/$userId/followers')
            .doc('$followId')
            .update({'isFollowed': false});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unfollowed successfully'),
          backgroundColor: Colors.green,
        ),
      );
//----------------------------------------------------------------
      return true;
    } catch (e) {
      print('unFollowUserService : $e');
    }
    return null;
  }
  // --------to check in 1st user's followers list is 2nd user exist or not---------

  Future<bool> checkFollower(String? userId, String? followId) async {
    bool exist = false;
    try {
      await firebaseFirestore
          .collection("users")
          .doc(userId)
          .collection("followers")
          .doc("$followId")
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      return false;
    }
  }
}
