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
  UserInformationDesignState createState() => UserInformationDesignState();
}

class UserInformationDesignState extends State<UserInformationDesign> {
  ImageProvider<Object> buildImage() {
    final image = widget.userImage == "noImage" ||
            widget.userImage!.isEmpty ||
            widget.userImage == null
        ? AssetImage("assets/images/defaultUser.png") // NEW
        : NetworkImage(widget.userImage!) as ImageProvider;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userName);
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
                if (widget.userName != AppGlobals.userName) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileView(
                              userId: widget.autherId,
                            )),
                  );
                }
              }),

          //============================
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.userName ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
