import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();

  SignUpScreen({Key? key}) : super(key: key);
}

class _SignUpScreenState extends State<SignUpScreen> {
  GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  LocationPermission _permission = LocationPermission.denied;
  final _formKey = GlobalKey<FormState>();
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var mobilenoController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String? _firstname;
  String? _lastname;
  String? _mobileno;
  String? _email;
  String? _password;
  bool _obscureText = true;
  Position? _currentPosition;
  bool isChecked = false;

  void validateCheckbox(bool value) {
    setState(() {
      isChecked = value;
    });
  }

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
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Create a new account',
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
                    "First Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*firstname*/
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: firstnameController,
                      keyboardType: TextInputType.name,
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
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstname = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*lastname*/
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: lastnameController,
                      keyboardType: TextInputType.name,
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
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastname = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Mobile No.",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*mobileno*/
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: mobilenoController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: '',
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
                          return 'Please enter your mobile no.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _mobileno = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "E-mail",
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
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        // Simple email validation using RegExp
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address.';
                        }
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            validateCheckbox(value ?? false);
                          },
                        ),
                        Text(
                          'I agree with terms and conditions',
                        ),
                      ],
                    )
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  /*signup*/ Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // If all validations pass, proceed with login logic
                          // For example, you can perform API calls for authentication here
                          // Replace this with your actual login logic

                          // Get the values from text controllers
                          if (isChecked) {
                            // Perform an action or navigate to another screen
                            String firstname = firstnameController.text.trim();
                            String lastname = lastnameController.text.trim();
                            String mobileno = mobilenoController.text.trim();
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            String imageUrl =
                                'https://randomuser.me/api/portraits/men/1.jpg'; // Default URL

                            Fluttertoast.showToast(
                              msg: 'SignUp successful!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('save_firstname', firstname);
                            prefs.setString('save_lastname', lastname);
                            prefs.setString('save_mobileno', mobileno);
                            prefs.setString('save_email', email);
                            prefs.setString('save_password', password);
                            prefs.setString('save_imageUrl', imageUrl);

                            // Navigate to a new screen after successful login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          } else {
                            // Show an error message or prevent the action
                            Fluttertoast.showToast(
                              msg:
                                  'Please accept terms and conditions before signup!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } else {}
                      },
                      child: const Text(
                        'Sign Up',
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
                        'Already a member?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          'Login',
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
                                builder: (context) => LoginScreen()),
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
