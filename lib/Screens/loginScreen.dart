import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patel_brothers/Screens/signupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();

  LoginScreen({Key? key}) : super(key: key);
}

class _LoginScreenState extends State<LoginScreen> {
  GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  LocationPermission _permission = LocationPermission.denied;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String? _email;
  String? _password;
  double? location;
  bool rememberMe = false;
  bool _obscureText = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    _permission = await _geolocator.requestPermission();
    if (_permission == LocationPermission.denied) {
      // Handle denied permission
      // You can show an error message or navigate to another screen
    } else if (_permission == LocationPermission.deniedForever) {
      // Handle denied forever permission
      // You can show a message and guide the user to settings
    } else {
      // Permission granted, navigate to login screen or get location
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });

      // Save location to SharedPreferences
      if (_currentPosition != null) {
        saveLocation(_currentPosition!);
      }

      // Proceed to the login screen or perform other actions with location
    } catch (e) {
      print('Error getting location: $e');
      // Handle location retrieval failure
    }
  }

  Future<void> saveLocation(Position position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);
  }

  Future<void> _login() async {
    final String apiUrl =
        'https://uat.humin.app/api/login'; // Replace with your API URL

    // Get the values from text controllers
    String username = emailController.text.trim();
    String password = passwordController.text.trim();

    // Create a JSON body to send in the POST request
    Map<String, String> body = {
      'employee_id': username,
      'userpassword': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successful login, handle the response data as needed
        var data = json.decode(response.body);

        if (data['message'] == 'success') {
          // Handle success message
          print('Login successful! Response: ${response.body}');
          // Show toast message
          Fluttertoast.showToast(
            msg: 'Login successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          //after the login REST api call && response code ==200
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('save_email', username);
          prefs.setString('save_password', password);
          prefs.setBool('isLoggedIn', true);

          // Navigate to a new screen after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (data['message'] == 'Invalid User or Password') {
          // Handle error message
          // Failed login, handle the error or display a message
          print('Login failed! Status code: ${response.statusCode}');
          Fluttertoast.showToast(
            msg: 'Login failed! Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        // Failed login, handle the error or display a message
        print('Login failed! Status code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Login failed! Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Error occurred during the request
      print('Error during login: $e');
      Fluttertoast.showToast(
        msg: 'Error during login. Please check your connection.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: () async {
            // Display a confirmation dialog when the back button is pressed
            bool exit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Confirm Exit?'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(false); // Return false when cancel is pressed
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // Return true when confirm is pressed
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
            return exit ?? false;
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/logo.png', // Replace with your logo asset path
                      width: 200, // Adjust the width as needed
                      height: 200, // Adjust the height as needed
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Space between logo and login fields
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Please Login to your account',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "E-mail/Mobile no.",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*email*/
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        /*if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }*/
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*password*/
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      // Toggles the visibility of text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        /*if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }*/
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              )
                            ]),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(width: 50),
                            // Adjust spacing between checkbox and button

                            TextButton(
                              onPressed: () {
                                // Implement your forgot password functionality here
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        )
                      ]),
                  const SizedBox(
                    height: 30,
                  ),
                  /*login*/
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If all validations pass, proceed with login logic
                          // For example, you can perform API calls for authentication here
                          // Replace this with your actual login logic

                          _login();
                        } else {}
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Opacity(
                    opacity: 0.5,
                    child: Text(
                      '                                                                            ',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New User?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
