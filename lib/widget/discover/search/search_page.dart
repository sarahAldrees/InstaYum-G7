import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_colors.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/model/user_model.dart';
import 'package:instayum/widget/discover/search/custom_dropdown.dart';

import 'search_recipe.dart';
import 'search_users.dart';

class SearchPage extends StatefulWidget {
  bool isFromMealPlan = false;
  String? mealDay;
  String? mealPlanTypeOfMeal;
  SearchPage(
      {Key? key,
      required this.isFromMealPlan,
      this.mealDay,
      this.mealPlanTypeOfMeal})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _ingredientsController = new TextEditingController();
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List _searchResults = [];
  List<DocumentSnapshot> _allRecipes = [];
  String searchText = "";

  bool isRecipes = true;
  bool showFilter = false;

  String? _selectedTypeOfMeal = ''; // 'Breakfast';
  String? _selectedCategory = ''; // 'Appetizers';
  String? _selectedCuisine = ''; // 'American';

  @override
  void initState() {
    super.initState();
    _getRecipesData();
  }

  _switchRecipes(bool val) {
    if (isRecipes != val) {
      _searchResults.clear();
      _searchController.clear();
      setState(() {
        isRecipes = val;
        showFilter = false;
      });
    }
  }

  // final Function(String)? onChangeFunction ;
  final TextEditingController? searchControllerOfCupertinoSearchTextField =
      new TextEditingController();

  searchAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFeb6d44),
      title: Text("Search"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFromMealPlan) {
      setState(() {
        searchText = 'Search for recipes';
        print("**************___");
      });
    } else {
      setState(() {
        searchText = 'Search';
      });
      print("________________________________");
    }
    return Scaffold(
      appBar: widget.isFromMealPlan ? null : searchAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // shrinkWrap: true,
          // physics: ScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // show search bar with filter
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 5),
                    // padding: EdgeInsets.symmetric(horizontal: AppGlobals.screenWidth * 0.1),
                    child: CupertinoSearchTextField(
                      placeholder: searchText,
                      controller: searchControllerOfCupertinoSearchTextField ??
                          TextEditingController(),
                      itemColor: AppColors
                          .primaryColor, // The X button and the search button in the search
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.grey),
                      ),
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                      padding: EdgeInsets.fromLTRB(20, 10, 12, 10),
                      onChanged: onSearchTextChanged,
                      onSubmitted: onSearchTextChanged,
                      // suffixIcon: suffixIcon,
                    ),
                  ),
                ),
                if (isRecipes)
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_alt,
                        color: Color(0xFFeb6d44),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        showFilter = !showFilter;
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 5),
            Flexible(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      if (!widget.isFromMealPlan)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _switchRecipes(true);
                              },
                              child: Container(
                                // margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                height: 45,
                                width: AppGlobals.screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: isRecipes
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "RECIPES",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: isRecipes
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                print("on tap working !!!!!!!!!!!!!");
                                _switchRecipes(false);
                              },
                              child: Container(
                                // margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                height: 45,
                                width: AppGlobals.screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: !isRecipes
                                      ? AppColors.primaryColor
                                      : Colors.grey[200],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "COOKING\nENTHUSIASTS",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: !isRecipes
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      Expanded(
                        child: isRecipes
                            ? SearchRecipe(
                                recipes:
                                    List<DocumentSnapshot>.from(_searchResults),
                              )
                            : SearchUsers(
                                users: List<UserModel>.from(_searchResults),
                                // _searchResults as List<UserModel>,
                              ),
                      ),
                    ],
                  ),
                  if (showFilter) _showFilterDialog(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getRecipesData() async {
    _allRecipes.clear();
    await firestoreInstance
        .collection('recipes')
        .where('is_public_recipe', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .get()
        .then((snapshot) {
      if (snapshot != null) {
        if (snapshot.docs.length > 0) {
          _allRecipes = snapshot.docs;
        }
      }
    });

    setState(() {});
  }

  void _searchFromFirestore(String searchkey, String ingredientsList,
      {bool withFilter = false}) async {
    print("0000000000000000000000000000000");
    print(searchkey);
    print(_selectedCategory);
    print(_selectedTypeOfMeal);
    print(_selectedCuisine);

    if (isRecipes) {
      //// search from recipes

      //hide filter if shown
      if (showFilter) {
        showFilter = false;
      }

      _allRecipes.forEach((recipe) {
        Map data = recipe.data() as Map<dynamic, dynamic>;
        String? _title = data['recipe_title'].toLowerCase();
        String? _category = data['category'];
        String? _cuisine = data['cuisine'];
        String? _typeOfMeal = data['type_of_meal'];
        int? _ingLength = data['length_of_ingredients'];

        if (withFilter) {
          if (ingredientsList != "") {
            print("YEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES");
            print(ingredientsList);
            //لان كان في اللنقث دائما يطلع واحد حتى لو ما كتبت شيء واتوقع السبب هذا لاننا انشئنا اللست
            //المهم خليته قبل ما ينشئ اللست يشيك اذا اليوزر كتب شيء او لا
            //طيب وش جابني انا هنا اصلا؟ انا بقولك
            // لما جيت بحل مشكلة السيرتش باستعمال الفلتر مع التايتل والله مدري وش صار بس اكتشفت هذا اللوجيك ايرور :)ا
            // المهم فيه ايرور لما ابحث باستعمال المكونات للمره الثانية يطلع ايرور :(ا
//-----------------------------------
//تحديث جديد :) حليت الايرور بحيث اني شلت الكنترولر من انبوت المقادير وخليت الاسناد يكون ب اون تشانج
//الحل له عيب واحد بس ماراح اقول انت اكتشفي والصدق العيب مو مره كبير
            List<String> _searchIngredients =
                ingredientsList.toLowerCase().split(',');

            //   if (_searchIngredients.isNotEmpty)

            print(_searchIngredients.length);
            var count = 0;
            //search by each ingredient

            outerLoop: //number of ingredients in recipe
            for (int si = 0; si < _searchIngredients.length; si++) {
              //   String _ing = (data['ing$i'] ?? '').toString().toLowerCase();

              innerLopp: //number of ingredients in search

              for (int i = 1; i <= _ingLength!; i++) {
                String _ing = (data['ing$i'] ?? '').toString().toLowerCase();
                _ing.trim();

                if (_ing.contains(_searchIngredients[si].trim()) &&
                    _title!.contains(searchkey) &&
                    _category!.contains(_selectedCategory!) &&
                    _cuisine!.contains(_selectedCuisine!) &&
                    _typeOfMeal!.contains(_selectedTypeOfMeal!)) {
                  count++;
                  //  break outerLoop;
                }
              }
              if (count == _searchIngredients.length) {
                _searchResults.add(recipe);
              }
            } //outer
          } else {
            //search by without ingredients
            if (_title!.contains(searchkey) &&
                //  _title.startsWith(searchkey) &&
                _category!.contains(_selectedCategory!) &&
                _cuisine!.contains(_selectedCuisine!) &&
                _typeOfMeal!.contains(_selectedTypeOfMeal!)) {
              _searchResults.add(recipe);
            }
          }
        } else {
          //search by just title
          if (_title!.startsWith(searchkey) || _title.contains(searchkey)) {
            _searchResults.add(recipe);
          }
        }
      });
    } else {
      await firestoreInstance
          .collection('users')
          .orderBy('username')
          .startAt([searchkey])
          .endAt([searchkey + '\uf8ff']) // need to be tested
          .get()
          .then((snapshot) {
            if (snapshot.docs.length > 0) {
              _searchResults = snapshot.docs.map((userdoc) {
                Map<String, dynamic> data = userdoc.data();
                UserModel user = UserModel.fromJson(data);
                user.userId = userdoc.id;
                return user;
              }).toList();
            }
          });
    }

    setState(() {});
  }

  onSearchTextChanged(String text) async {
    _searchResults.clear();
    text = text.trim().toLowerCase();
    _searchController.text = text;

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _searchFromFirestore(text, "");
  }

  Widget _showFilterDialog() {
    return Container(
      height: 300, //AppGlobals.screenHeight * 0.3,
      width: 250, //AppGlobals.screenWidth * 0.7,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //--------------ingredients textfield for search------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  _ingredientsController.text = value;
                },
                //controller: _ingredientsController,
                decoration: InputDecoration(
                  hintText: "ingredients",
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            //--------------dropdown list for Search------------
            CustomDropDown(
              hintText: 'Type of meal',
              list: AppGlobals.recipeType,
              selectedValue: _selectedTypeOfMeal,
              onChanged: (value) {
                setState(() => _selectedTypeOfMeal = value);
              },
            ),
            CustomDropDown(
              hintText: 'Category',
              list: AppGlobals.recipeCategories,
              selectedValue: _selectedCategory,
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            CustomDropDown(
              hintText: 'Cuisine',
              list: AppGlobals.cuisine,
              selectedValue: _selectedCuisine,
              onChanged: (value) {
                setState(() => _selectedCuisine = value);
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("111111111111111111111111111111");
                  print(_ingredientsController.text);

                  _searchResults.clear();
                  _searchFromFirestore(
                      _searchController.text, _ingredientsController.text,
                      withFilter: true);
                  _ingredientsController.text = "";
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColor.withOpacity(0.8),
                  // shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // fixedSize: Size(width ?? 80, height ?? 35),
                ),
                child: Center(
                  child: Text(
                    "Search",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
