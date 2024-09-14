import 'dart:async';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horcrux/models/cart.dart';
import 'package:horcrux/screens/login_screen.dart';
import 'package:horcrux/screens/cart_screen.dart';
import 'package:horcrux/screens/profile_page.dart';
import 'package:horcrux/screens/search_screen.dart';
import 'package:horcrux/screens/home_page.dart';
import 'package:horcrux/appTheme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as FB;
import 'package:horcrux/firebase_options.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  late int cartNum;

  static const List<String> _bottomNavBarImages = [
    'assets/icons/home',
    'assets/icons/search',
    'assets/icons/cart1',
    'assets/icons/user',
  ];

  static const List<String> _bottomNavBarTitles = [
    'Home',
    'Search',
    'Cart',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // loadCartNum();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildScreen(_selectedIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          _bottomNavBarImages.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == _selectedIndex
                  ? '${_bottomNavBarImages[index]}_filled.svg'
                  : '${_bottomNavBarImages[index]}.svg',
              width: 25,
              height: 25,
              colorFilter: index == _selectedIndex
                  ? ColorFilter.mode(Colors.black, BlendMode.srcIn)
                  : ColorFilter.mode(appGrey, BlendMode.srcIn),
            ),
            label: _bottomNavBarTitles[index],
            // label: index == 2
            //     ? "${_bottomNavBarTitles[index]} ($cartNum)"
            //     : _bottomNavBarTitles[index],
          ),
        ),
        currentIndex: _selectedIndex,
        unselectedItemColor: appGrey,
        selectedItemColor: appBlack,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return SearchScreen();
      case 2:
        return CartScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }
}

class AuthService {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FB.FirebaseUIAuth.configureProviders([
    GoogleProvider(
        clientId:
            "840528986993-5pep56fidk9oqv2079jdsbu9h5h657sj.apps.googleusercontent.com"),
  ]);

  runApp(MaterialApp(
    title: 'Swipe',
    debugShowCheckedModeBanner: false,
    home: FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final bool isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? MainApp() : LoginScreen();
      },
    ),
    theme: ThemeData(
      fontFamily: 'Poppins',
      splashColor: Colors.transparent,
    ),
  ));
}
