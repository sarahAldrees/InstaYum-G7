import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';

class FollowUserService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future followUser(
    BuildContext context, {
    String? followId,
  }) async {
    try {
      String? email;
      String? username;
      String? imageUrl;
      String? pushToken;

      print('followId: $followId');
      //------------get info of other user-------------
      DocumentSnapshot docSnapshot =
          await firebaseFirestore.collection('users').doc('$followId').get();

      if (docSnapshot != null) {
        print(' followUserData: ${docSnapshot.data()}');
        Map data = docSnapshot.data() as Map<String, dynamic>;
        email = data['email'];
        username = data['username'];
        imageUrl = data['image_url'];
        pushToken = data['pushToken'];
      }

      UserModel followUser = UserModel(
        email: email,
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
          .doc('$followId')
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
            .doc('$followId')
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are now following $username'),
          backgroundColor: Colors.green,
        ),
      );
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
