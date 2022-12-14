// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_designers/screens/home_screen.dart';
import 'package:flutter_for_designers/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: (FirebaseAuth.instance.currentUser == null)
                ? const LoginScreen()
                : const HomeScreen(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    );
  }
}
