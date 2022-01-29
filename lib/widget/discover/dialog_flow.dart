import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:instayum1/model/recipe.dart';
import 'package:instayum1/widget/discover/bot_suggestion.dart';
import 'package:instayum1/widget/discover/message.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ChatBotState createState() => new ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  static String userPreferredTypeOfMeal = '';
  static String userPreferredCategory = '';
  static String userPreferredCuisine = '';
  var botSuggestions;
  Messages theStartedMessage = Messages(
    text: "Welcome, I am InstaYum's chef do you need help?",
    name: "InstaYum",
    type: false,
  );

  List<Messages> messageList = <Messages>[];

  final TextEditingController _textController = new TextEditingController();

  void initState() {
    super.initState();
    messageList.add(theStartedMessage);
  }

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color(0xFFeb6d44),
                  ),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  List<String> suggestListAgent = ["Yes, I need help", 'No, thank you'];
  void agentResponse(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/instayum-chatbot-6077955177de.json")
            .build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogFlow.detectIntent(query);
    var botSuggestions = BotSuggestions(response.getListMessage());
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    // listOfResponses(botSuggestions.suggestions);
    print(botSuggestions.suggestions);
    setState(() {
      suggestListAgent = botSuggestions.suggestions;
    });

    print(suggestListAgent);
    Messages message = Messages(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      name: "InstaYum",
      type: false,
    );
    setState(() {
      messageList.insert(0, message);
    });
  }

  void _submitQuery(String text) {
    //user text
    print('user response in the chatbot***********');
    print(text);

    _textController.clear();
    Messages message = new Messages(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      messageList.insert(0, message);
    });
    agentResponse(text);

    if (text.toLowerCase().contains('breakfast')) {
      userPreferredTypeOfMeal = 'Breakfast';
      print("userPreferredTypeOfMeal is Breakfast");
    } else if (text.toLowerCase().contains('lunch')) {
      userPreferredTypeOfMeal = 'Lunch';
    } else if (text.toLowerCase().contains('dinner')) {
      userPreferredTypeOfMeal = 'Dinner';
    } else if (text.toLowerCase().contains('appetizers')) {
      userPreferredCategory = 'Appetizers';
    } else if (text.toLowerCase().contains('app')) {
      userPreferredCategory = 'Appetizers';
    } else if (text.toLowerCase().contains('appetizer')) {
      userPreferredCategory = 'Appetizers';
    } else if (text.toLowerCase().contains('main course')) {
      userPreferredCategory = 'Main course';
    } else if (text.toLowerCase().contains('main')) {
      userPreferredCategory = 'Main course';
    } else if (text.toLowerCase().contains('desserts')) {
      userPreferredCategory = 'Desserts';
    } else if (text.toLowerCase().contains('dess')) {
      userPreferredCategory = 'Desserts';
    } else if (text.toLowerCase().contains('dessert')) {
      userPreferredCategory = 'Desserts';
    } else if (text.toLowerCase().contains('drinks')) {
      userPreferredCategory = 'Drinks';
    } else if (text.toLowerCase().contains('drink')) {
      userPreferredCategory = 'Drinks';
    } else if (text.toLowerCase().contains('salads')) {
      userPreferredCategory = 'Salads';
    } else if (text.toLowerCase().contains('salad')) {
      userPreferredCategory = 'Salads';
    } else if (text.toLowerCase().contains('soups')) {
      userPreferredCategory = 'Soups';
    } else if (text.toLowerCase().contains('soup')) {
      userPreferredCategory = 'Soups';
    } else if (text.toLowerCase().contains('american')) {
      userPreferredCuisine = 'American';
    } else if (text.toLowerCase().contains('usa')) {
      userPreferredCuisine = 'American';
    } else if (text.toLowerCase().contains('america')) {
      userPreferredCuisine = 'American';
    } else if (text.toLowerCase().contains('asian')) {
      userPreferredCuisine = 'Asian';
    } else if (text.toLowerCase().contains('asia')) {
      userPreferredCuisine = 'Asian';
    } else if (text.toLowerCase().contains('brazilian')) {
      userPreferredCuisine = 'Brazilian';
    } else if (text.toLowerCase().contains('brazil')) {
      userPreferredCuisine = 'Brazilian';
    } else if (text.toLowerCase().contains('egyptian')) {
      userPreferredCuisine = 'Egyptian';
    } else if (text.toLowerCase().contains('egypt')) {
      userPreferredCuisine = 'Egyptian';
    } else if (text.toLowerCase().contains('french')) {
      userPreferredCuisine = 'French';
    } else if (text.toLowerCase().contains('france')) {
      userPreferredCuisine = 'French';
    } else if (text.toLowerCase().contains('gulf')) {
      userPreferredCuisine = 'Gulf';
    } else if (text.toLowerCase().contains('saudi arabia')) {
      userPreferredCuisine = 'Gulf';
    } else if (text.toLowerCase().contains('saudi')) {
      userPreferredCuisine = 'Gulf';
    } else if (text.toLowerCase().contains('indian')) {
      userPreferredCuisine = 'Indian';
    } else if (text.toLowerCase().contains('india')) {
      userPreferredCuisine = 'Indian';
    } else if (text.toLowerCase().contains('italian')) {
      userPreferredCuisine = 'Italian';
    } else if (text.toLowerCase().contains('italia')) {
      userPreferredCuisine = 'Italian';
    } else if (text.toLowerCase().contains('lebanese')) {
      userPreferredCuisine = 'Lebanese';
    } else if (text.toLowerCase().contains('mexican')) {
      userPreferredCuisine = 'Mexican';
    } else if (text.toLowerCase().contains('mexico')) {
      userPreferredCuisine = 'Mexican';
    } else if (text.toLowerCase().contains('turkish')) {
      userPreferredCuisine = 'Turkish';
    } else if (text.toLowerCase().contains('turkey')) {
      userPreferredCuisine = 'Turkish';
    }
    //  getData();
  } //method

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<Recipe> recpiesList = [];

  List<String> ingredientsList = [];

  List<String> dirctionsList = [];

  List<String> imageUrlsList = [];

  int lengthOfIngredients = 0;

  int lengthOfDirections = 0;

  int lengthOfImages = 0;

  void getRecipeObjects() {
    // User user = firebaseAuth.currentUser;
    // FirebaseFirestore.instance.collection("users").get()

    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(result.id)
            .collection("recipes")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) => {
              ingredientsList = [],
              dirctionsList = [],
              imageUrlsList = [],

              // String userPreferredCategory = '';
              // String userPreferredCuisine = '';
              if (doc.data()['type_of_meal'] == userPreferredTypeOfMeal &&
                  doc.data()['category'] == userPreferredCategory &&
                  doc.data()['cuisine'] == userPreferredCuisine &&
                  doc.data()['is_public_recipe'])
                {}
              else
                lengthOfIngredients = doc.data()['length_of_ingredients'],
              lengthOfDirections = doc.data()['length_of_directions'],
              lengthOfImages = doc.data()['image_count'],

              for (int i = 0; i < lengthOfIngredients; i++)
                {
                  {
                    ingredientsList.add(
                      doc.data()['ing${i + 1}'],
                    ),
                  }
                },
              for (int i = 0; i < lengthOfDirections; i++)
                {
                  dirctionsList.add(
                    doc.data()['dir${i + 1}'],
                  ),
                },
              for (int i = 0; i < lengthOfImages; i++)
                {
                  imageUrlsList.add(
                    doc.data()['img${i + 1}'],
                  ),
                },
              // recipe_image_url = doc.data()['recipe_image_url'],
              // widget.autherId = doc.data()['user_id'],
              recpiesList.add(
                Recipe(
                  autherId: result.id,
                  id: doc.id,
                  //imageURL: recipe_image_url,
                  recipeName: doc.data()['recipe_title'],
                  typeOfMeal: doc.data()['type_of_meal'],
                  category: doc.data()['category'],
                  cuisine: doc.data()['cuisine'],
                  mainImageURL: doc.data()["img1"],
                  dirctions: dirctionsList,
                  ingredients: ingredientsList,
                  imageUrls: imageUrlsList,
                ),
              ),
            },
          );
          setState(() {});
        });
      });
    });
  }

  Widget dynamicActionChip(String str) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: Colors.grey.shade600,
        child: Text(str[0].toUpperCase()),
      ),
      label: Text(str),
      onPressed: () {
        _submitQuery(str);
        print("7777777777777777777777777777777777777777777777777777777777");
        print(_textController.text);
        // _textController.text = 'wooow';
      },
    );
  }

  Widget dynamicWrapChips(List<String> suggestionList) {
    return Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: List<Widget>.generate(suggestionList.length, (int index) {
          return dynamicActionChip(suggestionList[index]);
        }));
  }

  List<String> suggestedMealType = ["breakfast", 'Lunch', "Dinner"];
  List<String> suggestedBreakfastCategory = [
    "appetizers",
    "main course",
    "drink"
  ];
  List<String> suggestedLunchOrDinnerCategory = [
    "appetizers",
    "main course",
    "salads",
    "soups",
    "desserts",
    "drink"
  ];

  // final _fireStore = FirebaseFirestore.instance;
  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _fireStore.collection('users').get();

  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => {}).toList();
  //   //for a specific field
  //   // final allData = querySnapshot.docs.map((doc) => doc.get('recipes'));

  //   print('**********************===***');
  //   print(allData);
  //   for (int i = 0; i < allData.length; i++) {
  //     print(allData.elementAt(i));
  //   }
  //   // print(allData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "InstaYum's Chef",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFeb6d44),
        elevation: 0,
      ),
      body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true, //To keep the latest messages at the bottom
                itemBuilder: (_, int index) => messageList[index],
                itemCount: messageList.length,
              ),
            ),
            dynamicWrapChips(suggestListAgent),
            _queryInputWidget(context),
          ]),
    );
  }
}
