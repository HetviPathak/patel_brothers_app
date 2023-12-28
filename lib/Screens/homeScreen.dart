import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ScreenOne(),
    ScreenTwo(),
    ScreenThree(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedItemColor: Colors.red.shade900,
        unselectedItemColor: Colors.black,
        elevation: 15,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: ''),
        ],
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          leading: IconButton(
            icon: Icon(Icons.menu), // Custom icon for the navigation drawer
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
          elevation: 50,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'Home Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favourite'),
          leading: IconButton(
            icon: Icon(Icons.menu), // Custom icon for the navigation drawer
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
          elevation: 50,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'Favourite Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          leading: IconButton(
            icon: Icon(Icons.menu), // Custom icon for the navigation drawer
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
          elevation: 50,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'Orders Screen',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();

  ProfileScreen({Key? key}) : super(key: key);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? city = "",
      email = "",
      password = "",
      firstname = "",
      lastname = "",
      mobileno = "",
      imageUrl = "";
  double? latitude, longitude;
  var addressController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValueFromSharedPreferences();
  }

  Future<void> getValueFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('save_email') ?? 'No value';
      password = prefs.getString('save_password') ?? 'No value';
      firstname = prefs.getString('save_firstname') ?? 'No value';
      lastname = prefs.getString('save_lastname') ?? 'No value';
      mobileno = prefs.getString('save_mobileno') ?? 'No value';
      imageUrl = prefs.getString('save_imageUrl') ?? '';

      latitude = prefs.getDouble('latitude');
      longitude = prefs.getDouble('longitude');

      passwordController.text = "Password: ${password!}";

      getCityFromCoordinates();
    });
  }

  Future<void> getCityFromCoordinates() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        setState(() {
          city = placemarks[0].locality ?? 'Unknown';
          addressController.text = "Address: ${city!}";
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.menu), // Custom icon for the navigation drawer
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Open the drawer
          },
        ),
        elevation: 50,
        backgroundColor: Colors.white,
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Column(children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl!), // Replace with your image
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                firstname! + ' ' + lastname!,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email!, // Replace with profile designation
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                "+91 " + mobileno!, // Replace with profile designation
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Account Details',
                    suffixIcon: Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: passwordController,
                  enabled: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Change Password',
                    suffixIcon: Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: addressController,
                  enabled: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    suffixIcon: Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Orders',
                    suffixIcon: Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              /*logout*/
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () async {
                    showLogoutDialog(context);

                    // Navigate to login screen or perform any logout actions here
                    print('Logged out. SharedPreferences data cleared.');
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout actions here
                // For example, clear data and navigate to login screen
                // ...
                clearData();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('save_email');
    await prefs.remove('save_password');
    await prefs.remove('isLoggedIn');
    await prefs.remove('save_firstname');
    await prefs.remove('save_lastname');
    await prefs.remove('save_mobileno');
    await prefs.remove('save_imageUrl');
    await prefs.clear(); // Clear all data stored in SharedPreferences

    Fluttertoast.showToast(
      msg: 'Logout successful!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Navigate to a new screen after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
