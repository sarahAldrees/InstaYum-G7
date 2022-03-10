import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/follow_and_notification/app_images.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    this.isRead = false,
    this.date,
    this.description,
    this.title1,
    this.title2,
    this.userImage,
    this.onTap,
  }) : super(key: key);
  final bool isRead;
  final String? userImage, title1, description, title2;
  final Timestamp? date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        tileColor: isRead == true ? Colors.white : Colors.grey[100],
        // User image circle
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Colors.grey[200],
              child: Image.network(
                userImage == null || userImage == 'noImage'
                    ? AppImages.defaultUserImage
                    : userImage!,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
        ),
        //notification description
        title: RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
            text: title1 ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: " ${description ?? ''} ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              TextSpan(text: title2 ?? ''),
            ],
          ),
        ),
        // notification date
      ),
    );
  }
}
