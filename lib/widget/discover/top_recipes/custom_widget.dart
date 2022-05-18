import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder? shapeBorder;

  const CustomWidget.rectangular({this.width = double.infinity, this.height})
      : shapeBorder = const RoundedRectangleBorder();

  const CustomWidget.circular(
      {this.width = double.infinity,
      this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: AppColors.primaryColor.withOpacity(0.2),
        highlightColor: Colors.grey[300]!,
        period: const Duration(seconds: 3),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder ?? const RoundedRectangleBorder(),
          ),
        ),
      );
}

class CustomShimmerWidget extends StatelessWidget {
  const CustomShimmerWidget({Key? key, this.isTopRecipes}) : super(key: key);
  final bool? isTopRecipes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTopRecipes == true ? "Top Weekly Recipes" : "New Recipes",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          isTopRecipes == true
              ? _topWeeklyRecipesLoading()
              : _newRecipesLoading(),
        ],
      ),
    );
  }

  Widget _topWeeklyRecipesLoading() {
    double height = AppGlobals.screenHeight * 0.3;
    double cardWidth = AppGlobals.screenWidth * 0.35;
    double cardHeight = AppGlobals.screenHeight * 0.25;

    return SizedBox(
      height: height,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryColor.withOpacity(0.2),
              highlightColor: Colors.grey[300]!,
              period: const Duration(seconds: 3),
              child: Container(
                height: cardHeight,
                width: cardWidth,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _newRecipesLoading() {
    double cardWidth = AppGlobals.screenWidth * 0.3;

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: ListTile(
            leading: const CustomWidget.rectangular(width: 60, height: 50),
            title: Align(
              alignment: Alignment.centerLeft,
              child: CustomWidget.rectangular(
                height: 16,
                width: cardWidth,
              ),
            ),
            subtitle: const CustomWidget.rectangular(height: 14),
          ),
        );
      },
    );
  }
}
