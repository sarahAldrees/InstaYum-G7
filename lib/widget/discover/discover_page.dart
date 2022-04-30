import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/discover/chatbot/dialog_flow.dart';
import 'package:instayum/widget/recipe_view/my_recipes_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../model/recipe.dart';
import '../recipe_view/my_recipes_screen.dart';
import 'search/search_page.dart';
import 'top_recipes/custom_widget.dart';
import 'top_recipes/new_recipes_list.dart';
import 'top_recipes/top_recipe_service.dart';
import 'top_recipes/top_recipes_list.dart';

//import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Discover();
}

class Discover extends State<DiscoverPage> {
  bool value = false;
  bool _fetchTopRecipes = false;

  List<DocumentSnapshot> _allRecipes = [];
  List<Recipe> _bookmarkRecipes = [];
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getAllRecipes();
  }

  //final cookingEnthusist = UserPreferences.myCooking_Enthusiast;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatBot()));
        },
        child: Image.asset(
          'assets/images/InstaYum_chatbot.png',
          height: 300,
        ),
        //Icon(Icons.support_agent_rounded),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.,
                children: [
                  Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      //Go to search page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(
                              isFromMealPlan: false,
                              mealDay: "",
                              mealPlanTypeOfMeal: "",
                            ),
                          ));
                    }, // Image tapped
                    child: Image.asset(
                      'assets/images/search128.png',
                      fit: BoxFit.cover, // Fixes border issues
                      // width: 110.0,
                      height: 40,
                    ),
                  )
                ],
              ),
            ),
            _fetchTopRecipes
                ? TopWeeklyRecipes(recipes: _bookmarkRecipes)
                : const CustomShimmerWidget(isTopRecipes: true),
            _fetchTopRecipes
                ? NewRecipesForU(recipes: _allRecipes)
                : const CustomShimmerWidget(isTopRecipes: false)
          ],
        ),
      ),
    );
  }

  void _getAllRecipes() async {
    // Get all recipes
    _allRecipes.clear();
    _bookmarkRecipes.clear();

    await firestoreInstance
        .collection('recipes')
        .where('is_public_recipe', isEqualTo: true)
        .orderBy('timestamp',
            descending:
                true) // we have to choose ethier the most recent add recipes -> timestamp or random -> position if here we need to implement a simple method to reassign the position a new random number.
        .get()
        .then((recipesSnapshot) async {
      if (recipesSnapshot.docs.isNotEmpty) {
        _allRecipes = recipesSnapshot.docs;
        _bookmarkRecipes =
            await TopRecipeService().fetchAndCalculateTopRecipes();
        _fetchTopRecipes = true;
        if (mounted) setState(() {});
      }
    }).then((nothing) async {
      await Future.delayed(const Duration(milliseconds: 900), () {});
      setState(() {});
      if (mounted) (() {});
    });
  }
}
