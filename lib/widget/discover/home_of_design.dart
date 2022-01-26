import 'package:flutter/material.dart';
import 'package:instayum1/widget/discover/recipe_card.dart';

class HomeOfD extends StatefulWidget {
  @override
  HomeOfDState createState() => HomeOfDState();
}

class HomeOfDState extends State<HomeOfD> {
  @override
  Widget build(BuildContext context) {
    return Column(
      //appBar: AppBar(
      // title: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Icon(Icons.restaurant_menu),
      //     SizedBox(width: 10),
      //     Text('Food Recipes'),
      //   ],
      // ),
      // ),
      children: [
        RecipeCard(
          title: 'My recipe',
          rating: '4.9',
          cookTime: '30 min',
          thumbnailUrl:
              'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360',
        )
      ],
    );
  }
}
