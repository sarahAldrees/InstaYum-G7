import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/recipe_view/recipe_view.dart';
import 'package:share_plus/share_plus.dart';

class ShareRecipeService {
  static const String appName = 'InstaYum';
  static const String packageName = 'com.example.instayum';
  //static const String appStoreId = '123456789';
  static const String deepLinkUrlPrefix =
      'https://instayum.page.link'; //domain name that uses the dynamic links.

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<String?> createAndShareLink(
      {String? recipeId,
      String? userId,
      String? title,
      String ingredients = "",
      String dirctions = ""}) async {
    String? _link;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: deepLinkUrlPrefix,
      link: Uri.parse('$deepLinkUrlPrefix/?recipeId=$recipeId&userId=$userId'),
      // 'https://${ deepLinkName}/?recipeId=$userId&userId=$userId'),
      androidParameters: const AndroidParameters(
        packageName: packageName,
        minimumVersion: 1,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: packageName,
      //   appStoreId: appStoreId,
      //   minimumVersion: '1',
      // ),
    );

    final ShortDynamicLink dynamicUrl =
        await dynamicLinks.buildShortLink(parameters);
    _link = dynamicUrl.shortUrl.toString();

    Future.delayed(Duration.zero, () {
      Share.share(
          "Check out this recipe.👇\n$_link \n\n\"The link just available for Android palteform until now.\"\n-------------------------------\nRecipe name: $title. \n\nIngredients: \n$ingredients \n Dirctions: \n$dirctions \n ");
    });
    return _link;
  }

  void initDynamicLinks(BuildContext context) async {
    Stream<PendingDynamicLinkData> linkStream =
        dynamicLinks.onLink; //to detect if the user has app

    linkStream.listen(
      (PendingDynamicLinkData? dynamicLink) {
        if (dynamicLink != null) {
          final Uri? deepLink = dynamicLink.link;

          if (deepLink != null) {
            Map<String, String> queryParams = deepLink.queryParameters;

            if (queryParams.isNotEmpty) {
              if (queryParams.containsKey("recipeId")) {
                String? recipeId = queryParams[
                    'recipeId']; // take recipe Id from the intiated link
                String? userId = queryParams['userId'];

                _navigateToRecipe(
                  context,
                  recipeId,
                  userId,
                );
              }
            }
          }
        }
      },
      onDone: () {},
      onError: (e) async {},
    );

    //Getting the link and details from Link
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink(); //----------------

    if (data == null) {
      //App is not opened using the DeepLinks(oppen app or navigar to google play)
      return;
    }

    final Uri? deepLink = data.link;
    if (deepLink != null) {
      Map<String, dynamic> queryParameters = deepLink.queryParameters;
      if (deepLink.queryParameters.isNotEmpty) {
        if (queryParameters.containsKey("recipeId")) {
          String? recipeId = deepLink.queryParameters['recipeId'];
          String? userId = deepLink.queryParameters['userId'];

          _navigateToRecipe(
            context,
            recipeId,
            userId,
          );
        }
      }
    }
  }

  void _navigateToRecipe(
      BuildContext context, String? recipeId, String? userId) {
    if (recipeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (conetxt) => RecipeView(
            recipeid: recipeId,
            autherId: userId,
            isFromMealPlan: false,
          ),
        ),
      );
    }
  }
}
