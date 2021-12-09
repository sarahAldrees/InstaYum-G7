import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/screen/auth_screen.dart';
import 'package:instayum1/screen/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instayum1/main_pages.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  runApp(Main());
}

class Main extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    // it mean he is authintecated
                    return MainPages();
                  } else {
                    return AuthScreen();
                  } //otherwise he does not have an accoun and return him to authScreen
                }),
          );
        });
  }
}
