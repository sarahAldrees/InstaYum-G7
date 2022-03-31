class AppGlobals {
  static double screenHeight = 800;
  static double screenWidth = 350;
  static String? userId;
  static String? userName;
  static String? userImage;
  // static String? fullName;
  static List<String?> shoppingList = [];
  static String? email;
  static String? pushToken;
  static List<String?> allFollowing = [];
  //-----------------------dropdown list for classification-----------------
  static final recipeType = ['Breakfast', 'Lunch', 'Dinner'];

  static final recipeCategories = [
    'Appetizers',
    'Main course',
    'Desserts',
    'Drinks',
    'Salads',
    'Soups',
  ];
  static final cuisine = [
    'American',
    'Asian',
    'Brazilian',
    'Egyptian',
    'French',
    'Gulf',
    'Indian',
    'Italian',
    'Lebanese',
    'Mexican',
    'Turkish',
    'Other'
  ];

  void resetGlobals() {
    userId = null;
    userName = null;
    userImage = null;
    // fullName = null;
    shoppingList.clear();
    email = null;
    pushToken = null;
    allFollowing.clear();
  }
}
