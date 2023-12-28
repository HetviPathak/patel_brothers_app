import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay using Future.delayed and navigate to the next screen after 2 seconds
    checkLoginStatus(context);
  }

  void checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Delay for a moment to simulate loading
    await Future.delayed(Duration(seconds: 3));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            isLoggedIn ? HomeScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_image.png'),
            // Replace with your splash image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
