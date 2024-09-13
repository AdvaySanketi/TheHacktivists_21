import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sling/models/cart.dart';
import 'package:sling/screens/onboarding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'Welcome, ${FirebaseAuth.instance.currentUser!.displayName}',
      //           style: TextStyle(fontSize: 16),
      //         ),
      //         Text(
      //           'Email: ${FirebaseAuth.instance.currentUser!.email}',
      //           style: TextStyle(fontSize: 16),
      //         ),
      //         Text(
      //           'UID: ${FirebaseAuth.instance.currentUser!.uid}',
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       ],
      //     ),
      //   ),
      // );

      var resp = await APIHelper.getAuth(
          FirebaseAuth.instance.currentUser!.displayName!,
          FirebaseAuth.instance.currentUser!.email!,
          FirebaseAuth.instance.currentUser!.uid);

      if (resp['success'] == true) {
        if (resp['response']['onBoardingStage'] != '2') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OnBoarding(
                      stateValue:
                          int.parse(resp['response']['onBoardingStage']),
                    )),
          );
        } else {
          await AuthService.setLoggedIn(true);
          var resp = await APIHelper.getCart();
          await CartService.setCartNum(resp['response'].length);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainApp()),
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to sign in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 30),
              child: Center(
                child: Text(
                  "Sling",
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 70.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Aladin',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _signInWithGoogle(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBlack,
                        ),
                        child: _isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ))
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.google,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Sign In with Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => MainApp()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBlack,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.apple,
                                size: 30, color: Colors.white),
                            SizedBox(width: 15),
                            Text(
                              'Sign In with Apple',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Image.asset(
        'assets/login_bg.png',
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
