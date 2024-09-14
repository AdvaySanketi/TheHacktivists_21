import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:horcrux/models/cart.dart';

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
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await GoogleSignIn().signIn();
      } catch (e) {}
      // final GoogleSignInAuthentication googleSignInAuthentication =
      //     await googleSignInAccount!.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleSignInAuthentication.accessToken,
      //   idToken: googleSignInAuthentication.idToken,
      // );

      // await FirebaseAuth.instance.signInWithCredential(credential);

      var resp = await APIHelper.getAuth('Test', 'test@gmail.com');

      if (resp['success'] == true) {
        await AuthService.setLoggedIn(true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainApp()),
        );
      }
    } catch (e) {
      debugPrint('Failed to sign in with Google: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 30),
              child: Center(
                child: Text(
                  "Swipe",
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
                mainAxisAlignment: MainAxisAlignment.center,
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
