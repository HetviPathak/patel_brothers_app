import 'package:flutter/material.dart';

import 'Screens/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Setting debug banner to false
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black),
          // Change default text color here
        ),
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black, // Change cursor color here
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.green.shade900, // Set your desired icon color here
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.green.shade900, // Set your desired text color here
              fontWeight: FontWeight.bold,
              fontSize: 25 // Optional: adjust the font weight
              ),
        ),
      ),
      home: SplashScreen(), // Set SplashScreen as your initial screen
    );
  }
}
