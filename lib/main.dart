import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_taking_app/screens/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'auth/authscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (userSnapshot.connectionState == ConnectionState.active) {
              if (userSnapshot.hasData) {
                print('The user is already logged in');
                return const Home();
              } else {
                print('The user didn\'t login yet');
                return const AuthScreen();
              }
            } else if (userSnapshot.hasError) {
              return const Center(
                child: Text('Error occured'),
              );
            }
            return const Text("");
          }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blue),
    );
  }
}
