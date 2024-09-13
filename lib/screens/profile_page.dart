import 'package:firebase_core/firebase_core.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/screens/faq_page.dart';
import 'package:sling/screens/orders_screen.dart';
import 'package:sling/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sling/screens/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 48,
                  backgroundImage: AssetImage('assets/icons/logo.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 18.0, left: 8.0, right: 8.0, top: 8.0),
                  child: Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text('Your Wardrobe',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('View and Manage your Liked Clothes'),
                  leading: Image.asset(
                    'assets/icons/closet.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: appBlack),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => WishlistScreen())),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Past Orders',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('View and Manage your Past Orders'),
                  leading: Image.asset(
                    'assets/icons/orders.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: appBlack),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => OrdersScreen())),
                ),
                Divider(),
                ListTile(
                  title: Text('Settings',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Privacy and logout'),
                  leading: Image.asset(
                    'assets/icons/settings.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: appBlack),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SettingsPage())),
                ),
                Divider(),
                ListTile(
                  title: Text('Help & Support',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Help center and legal support'),
                  leading: Image.asset(
                    'assets/icons/support.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: appBlack,
                  ),
                  onTap: () {
                    var result = APIHelper.deleteFromWishlist("8056377114790");
                    print(result);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('FAQ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Questions and Answer'),
                  leading: Image.asset(
                    'assets/icons/faq.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: Icon(Icons.chevron_right, color: appBlack),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => FaqPage())),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
