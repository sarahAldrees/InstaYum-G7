import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class userinfo extends StatelessWidget {
  String name;
  String uImage;

  userinfo(this.name, this.uImage);

  Widget buildImage() {
    final image = uImage == "noImage" || uImage.isEmpty || uImage == null
        ? AssetImage("assets/images/defaultUser.png") // NEW
        : NetworkImage(uImage);

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
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
