import 'package:firebase_auth/firebase_auth.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/main.dart';
import 'package:horcrux/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'change_language_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: appBlack,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.grey[700]),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
            builder: (builder, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'General',
                              style: TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          ListTile(
                            title: Text('Language A / का'),
                            leading: Image.asset(
                              'assets/icons/language.png',
                              fit: BoxFit.scaleDown,
                              width: 20,
                              height: 20,
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            title: Text('Notifications'),
                            leading: Image.asset(
                              'assets/icons/notifications.png',
                              fit: BoxFit.scaleDown,
                              width: 20,
                              height: 20,
                            ),
                            onTap: () => {},
                          ),
                          ListTile(
                            title: Text('Legal & About'),
                            leading: Image.asset(
                              'assets/icons/legal.png',
                              fit: BoxFit.scaleDown,
                              width: 20,
                              height: 20,
                            ),
                            onTap: () => {},
                          ),
                          ListTile(
                            title: Text('About Us'),
                            leading: Image.asset(
                              'assets/icons/about_us.png',
                              fit: BoxFit.scaleDown,
                              width: 20,
                              height: 20,
                            ),
                            onTap: () {},
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          ListTile(
                            title: Text('Sign out'),
                            leading: Image.asset(
                              'assets/icons/sign_out.png',
                              fit: BoxFit.scaleDown,
                              width: 20,
                              height: 20,
                            ),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              await AuthService.setLoggedIn(false);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
