import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/models/clothing.dart';
import 'package:horcrux/screens/view_product_page.dart';

class WishlistScreen extends StatefulWidget {
  WishlistScreen();

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<dynamic> wishlistResults = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    try {
      List<dynamic> clothingwishlistResults;
      Map<String, dynamic> resp = await APIHelper.getWishlist();
      clothingwishlistResults = resp['response'].toList();
      setState(() {
        wishlistResults = clothingwishlistResults;
      });
    } catch (e) {
      print("Error fetching wishlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              // '${FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0]}\'s Wishlist'),
              "Advay's Wishlist"),
          centerTitle: true,
        ),
        body: wishlistResults.isEmpty
            ? Padding(
                padding: EdgeInsets.only(bottom: 50, left: 16.0, right: 16.0),
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have not liked anything yet :(',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Try liking some products.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )))
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 12.0,
                      bottom: 12.0,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 7.0,
                                mainAxisSpacing: 7.0,
                                childAspectRatio: 0.76, //0.54
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: wishlistResults.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    print(wishlistResults[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewProductPage(
                                          product: ClothingItem(
                                              id: wishlistResults[index].id,
                                              name: wishlistResults[index].name,
                                              price: '0',
                                              seller:
                                                  wishlistResults[index].seller,
                                              image:
                                                  wishlistResults[index].image,
                                              images: [
                                                wishlistResults[index].image
                                              ]),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: WishlistCard(
                                              dressName:
                                                  wishlistResults[index].name,
                                              imagePath:
                                                  wishlistResults[index].image,
                                              seller:
                                                  wishlistResults[index].seller,
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ]))));
  }
}

class WishlistCard extends StatelessWidget {
  final String imagePath;
  final String dressName;
  final String seller;

  const WishlistCard({
    required this.imagePath,
    required this.dressName,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        dressName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      seller,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[300],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
