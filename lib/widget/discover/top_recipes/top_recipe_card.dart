import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';

import '../../follow_and_notification/app_images.dart';

class TopRecipeCard extends StatefulWidget {
  const TopRecipeCard(
      {Key? key, this.index, this.title, this.image, this.onTap, this.recipeId})
      : super(key: key);
  final int? index;
  final String? title, image, recipeId;
  final VoidCallback? onTap;

  @override
  State<TopRecipeCard> createState() => _TopRecipeCardState();
}

class _TopRecipeCardState extends State<TopRecipeCard> {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  double cardHeight = AppGlobals.screenHeight * 0.27;
  double cardWidth = AppGlobals.screenWidth * 0.37;

  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _getRecipeRating();
  }

  _getRecipeRating() {
    firestoreInstance
        .collection('recipes')
        .doc(widget.recipeId)
        .collection("rating")
        .doc("recipeRating")
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic>? data = value.data();
        if (data != null) {
          _rating = data['average_rating'];
          if (mounted) setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      widget.image ?? AppImages.noRecipeImage,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      // height: AppGlobals.screenHeight * 0.22,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    widget.title ?? '',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                RateWidget(rating: _rating),
              ],
            ),
          ),
          RankWidget(rank: (widget.index ?? 0) + 1),
        ],
      ),
    );
  }
}

class RankWidget extends StatelessWidget {
  const RankWidget({Key? key, this.rank}) : super(key: key);
  final int? rank;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.primaryColor,
      ),
      child: Center(
        child: Text(
          "${rank ?? ''}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RateWidget extends StatelessWidget {
  const RateWidget({Key? key, this.rating}) : super(key: key);
  final double? rating;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.star,
          size: 18,
          color: Colors.amber,
        ),
        const SizedBox(width: 5),
        Text(
          (rating ?? 0).toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
