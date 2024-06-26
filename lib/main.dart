// simple note taking app using firebase firestore
//CRUD OPERATION ON FIREBASE FIRESTORE DATABASE

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/firebase_options.dart';
import 'package:firebase_test/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  //initializing fir
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black, fill: 0.5),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.pink[100])),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
