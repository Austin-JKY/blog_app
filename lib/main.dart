import 'package:blog_app_test/contant/Contant.dart';
import 'package:blog_app_test/screen/Nav.dart';
import 'package:blog_app_test/screen/login_page/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: green)),
    );
  }
}
