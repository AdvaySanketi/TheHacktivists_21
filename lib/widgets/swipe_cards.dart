import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/screens/view_product_page.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:horcrux/models/clothing.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef VoidCallback = void Function();

class SwipeCardsWidget extends StatefulWidget {
  SwipeCardsWidget({Key? key, required this.context}) : super(key: key);

  final BuildContext context;
  late VoidCallback? rewind;

  @override
  _SwipeCardsState createState() => _SwipeCardsState(context);
}

class _SwipeCardsState extends State<SwipeCardsWidget> {
  final BuildContext context;
  _SwipeCardsState(this.context);

  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine = MatchEngine(swipeItems: []);
  bool _matchEngineReady = false;
  bool _apiMode = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late FToast fToast;
  bool _liked = false;
  bool _disliked = false;
  bool _cart = false;

  Widget buildToastWidget(String message, IconData icon, Color color) {
    Color lighterColor = color.withOpacity(0.8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: lighterColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Container(
              width: 200,
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                softWrap: true,
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _fetchRecommendation();
  }

  void rewind() {
    _matchEngine!.rewindMatch();
  }

  Future<void> _fetchRecommendation() async {
    try {
      List<ClothingItem> clothingProducts;
      if (_apiMode) {
        Map<String, dynamic> resp = await APIHelper.getRecommendation();
        clothingProducts = resp['response'].toList();
        await _preloadImages(clothingProducts);
      } else {
        clothingProducts = products;
      }

      for (int i = 0; i < clothingProducts.length; i++) {
        if (_apiMode) {
          var resp = await APIHelper.getProduct(clothingProducts[i].id!);
          List<dynamic> results = resp['response'].toList();
        }
        _swipeItems.add(SwipeItem(
          content: clothingProducts[i],
          likeAction: () async {
            dynamic resp = await APIHelper.postInteraction(
                clothingProducts[i].id!, 'LIKE');
            if (resp['success']) {
              _showToast("Liked ${clothingProducts[i].name}",
                  Icons.thumb_up_alt, Colors.green);
            } else {
              _showToast(
                  "Error, Like Failed", Icons.dangerous_outlined, Colors.black);
            }
          },
          nopeAction: () async {
            dynamic resp = await APIHelper.postInteraction(
                clothingProducts[i].id!, 'DISLIKE');
            if (resp['success']) {
              _showToast("Disliked ${clothingProducts[i].name}",
                  Icons.thumb_down_alt, Colors.red);
            } else {
              _showToast("Error, Dislike Failed", Icons.dangerous_outlined,
                  Colors.black);
            }
          },
          superlikeAction: () async {
            dynamic resp = await APIHelper.postInteraction(
                clothingProducts[i].id!, 'ADDTOCART');
            if (resp['success']) {
              if (_apiMode) {
                await APIHelper.addToCart(
                    clothingProducts[i].id!, clothingProducts[i].id, 1);
              }
              _showToast("${clothingProducts[i].name} added to Cart",
                  Icons.shopping_cart, Colors.blue);
            } else {
              _showToast("Error, Add to Cart Failed", Icons.dangerous_outlined,
                  Colors.black);
            }
          },
        ));
      }
      setState(() {
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        _matchEngineReady = true;
      });
    } catch (e) {
      print("Error fetching recommendation: $e");
    }
  }

  Future<void> _preloadImages(List<ClothingItem> clothingProducts) async {
    for (var product in clothingProducts) {
      await precacheImage(NetworkImage(product.image), context);
    }
  }

  void _showToast(String message, IconData icon, Color color) {
    fToast.showToast(
      child: buildToastWidget(message, icon, color),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      child: Container(
        child: Stack(
          children: [
            !_matchEngineReady
                ? Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.black,
                        rightDotColor: Colors.grey,
                        size: 70),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    child: SwipeCards(
                      matchEngine: _matchEngine!,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 120.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 20.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              print(_swipeItems[index].content.images);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewProductPage(
                                    product: _swipeItems[index].content,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              setState(() {
                                _apiMode = !_apiMode;
                                _matchEngineReady = false;
                              });
                              _swipeItems = [];
                              _fetchRecommendation();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _apiMode
                                      ? Image.network(
                                          _swipeItems[index].content.image,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          _swipeItems[index].content.image,
                                          fit: BoxFit.cover,
                                        ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            _swipeItems[index].content.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            _swipeItems[index].content.seller,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        _apiMode
                                            ? '₹${_swipeItems[index].content.apiprice}'
                                            : '₹${_swipeItems[index].content.price}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {},
                      itemChanged: (SwipeItem item, int index) {
                        print("item: ${item.content.name}, index: $index");
                        if (index == (_swipeItems.length - 2)) {
                          _swipeItems.removeRange(0, 8);
                          _fetchRecommendation();
                        }
                      },
                      leftSwipeAllowed: true, // Like
                      rightSwipeAllowed: true, // Dislike
                      upSwipeAllowed: true, // Add to Cart
                      fillSpace: true,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
