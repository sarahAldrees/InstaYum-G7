import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/widget/profile/user_profile_view.dart';

class UserInformationDesign extends StatefulWidget {
  String? autherId;
  String? userName;
  String? userImage;
  UserInformationDesign(this.autherId, this.userName, this.userImage);
  @override
  UserInformationDesignState createState() =>
      UserInformationDesignState(this.autherId, this.userImage, this.userName);
}

class UserInformationDesignState extends State<UserInformationDesign> {
  String? autherId;
  String? userName;
  String? userImage;
  UserInformationDesignState(this.autherId, this.userName, this.userImage);

  ImageProvider<Object> buildImage() {
    final image =
        userImage == "noImage" || userImage!.isEmpty || userImage == null
            ? AssetImage("assets/images/defaultUser.png") // NEW
            : NetworkImage(userImage!) as ImageProvider;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          //=========================

          InkResponse(
              child: Container(
                margin: EdgeInsets.only(left: 7),
                width: 45,
                height: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(fit: BoxFit.fill, image: buildImage())),
              ),
              onTap: () {
                if (userName != AppGlobals.userName) {}
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfileView(
                            userId: autherId,
                          )),
                );
              }),

          //============================
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              userName ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
