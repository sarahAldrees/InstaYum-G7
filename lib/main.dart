import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum/constant/app_globals.dart';
import 'package:instayum/widget/auth/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instayum/main_pages.dart';
import 'package:flutter/services.dart';
import 'package:instayum/widget/admin/admin_home_page.dart';
import 'package:instayum/widget/follow_and_notification/notification_service.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().registerNotification();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  runApp(Main());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<DocumentSnapshot>? futureUser;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: FutureBuilder(
          future: _initialization,
          builder: (context, appSnapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              title: 'InstaYum',
              theme: ThemeData(
                //primarySwatch: Colors.orangeAccent,
                backgroundColor: Color(0xFFeb6d44),
                accentColor: Color(0xFFeb6d44),
                accentColorBrightness: Brightness.dark,
                buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Color(0xFFeb6d44),
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // the onAuthStateChanged such as change when the user creat new account or login
              home:
                  firebaseAuth.currentUser != null ? MainPages() : AuthScreen(),

              // StreamBuilder(
              //     stream: FirebaseAuth.instance.authStateChanges(),
              //     builder: (context, userSnapshot) {
              //       if (userSnapshot.hasData) {
              //         // it mean he is authintecated
              //         if (AuthScreenState.isAdmin)
              //           return AdminHomePage();
              //         else
              //           return MainPages();
              //       } else {
              //         return AuthScreen();
              //       } //otherwise he does not have an accoun and return him to authScreen
              //     }),
            );
          }),
    );
  }

  Future getData() async {
    User? user = firebaseAuth.currentUser;
    if (user != null && AppGlobals.userId == null) {
      futureUser = firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .get()
          .then((userData) {
        Map data = userData.data()!;

        AppGlobals.email = data['email'];
        AppGlobals.userName = data['username'];
        // AppGlobals.fullName = data['fullName'];
        AppGlobals.shoppingList = List.from(data['shoppingList']);
        AppGlobals.pushToken = data['pushToken'];
        AppGlobals.userImage = data['image_url'];
        AppGlobals.userId = user.uid;

        print('userId: ' + AppGlobals.userId!);
        return userData;
      });
      await Future.delayed(Duration(seconds: 2));
    }
    setState(() {
      isLoading = false;
    });
  }
}
