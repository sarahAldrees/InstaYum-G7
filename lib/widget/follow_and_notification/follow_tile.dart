import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';

class FollowTile extends StatelessWidget {
  const FollowTile({
    Key? key,
    this.followTap,
    this.name,
    this.userName,
    this.userImage,
    this.buttonText,
    this.showButton = true,
    this.userTap,
  }) : super(key: key);
  final bool showButton;
  final String? userImage, name, userName, buttonText;
  final VoidCallback? followTap, userTap;
  static bool inSearchPage = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: userTap,
      // User image circle
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            color: Colors.grey[200],
            child: Image.network(
              userImage == null || userImage == 'noImage'
                  ? "https://global-uploads.webflow.com/5e4627609401e01182af1cce/5eb13bfdb4659efea4f8dace_profile-dummy.png"
                  : userImage!,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
      //Follow User Display Name
      title: Text(
        name ?? '',
        maxLines: 1,
        softWrap: true,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      //Follow UserName
      subtitle: Text(
        "@${userName ?? ''}",
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
      ),
      // Follow Button
      trailing: inSearchPage == false
          ? ElevatedButton(
              onPressed: followTap,
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor.withOpacity(0.8),
                // shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(90, 35),
              ),
              child: Center(
                child: Text(
                  buttonText ?? 'Follow',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // color: isActive ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget Trailing() {
    if (inSearchPage) {
      return ElevatedButton(
        onPressed: followTap,
        style: ElevatedButton.styleFrom(
          primary: AppColors.primaryColor.withOpacity(0.8),
          // shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(90, 35),
        ),
        child: Center(
          child: Text(
            buttonText ?? 'Follow',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
