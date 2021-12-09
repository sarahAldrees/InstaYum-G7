import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInformationDesign extends StatelessWidget {
  String userName;
  String userImage;

  UserInformationDesign(this.userName, this.userImage);

  Widget buildImage() {
    final image =
        userImage == "noImage" || userImage.isEmpty || userImage == null
            ? AssetImage("assets/images/defaultUser.png") // NEW
            : NetworkImage(userImage);

    return InkResponse(
        child: Container(
          margin: EdgeInsets.only(left: 7),
          width: 45,
          height: 55,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(fit: BoxFit.fill, image: image)),
        ),
        onTap: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          buildImage(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
