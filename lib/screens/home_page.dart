import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/main.dart';
import 'package:sling/models/address.dart';
import 'package:sling/models/cart.dart';
import 'package:sling/screens/view_product_page.dart';
import 'package:sling/widgets/filters_modal.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:sling/models/clothing.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine = MatchEngine(swipeItems: []);
  bool _matchEngineReady = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late FToast fToast;
  bool swipe_allow = !over;

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
    print(over);
    if (over) {
      recs_over();
    } else {
      _fetchRecommendation(false);
      fToast = FToast();
      fToast.init(context);
    }
  }

  void rewind() {
    _matchEngine!.rewindMatch();
  }

  void recs_over() {
    _swipeItems = [
      SwipeItem(
          content: ClothingItem(
              id: '0',
              name: 'You are out of recommendations!',
              price: '0',
              seller: 'Please come back after some time :)',
              image: ''))
    ];
    setState(() {
      _matchEngineReady = true;
    });
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Future<void> _fetchRecommendation(bool reload) async {
    try {
      if (recResults.isEmpty || reload) {
        Map<String, dynamic> resp = await APIHelper.getRecommendation();
        List<ClothingItem> clothingProducts = resp['response'].toList();
        if (clothingProducts.isEmpty) {
          setState(() {
            over = true;
            swipe_allow = false;
          });
          recs_over();
        } else {
          setState(() {
            _matchEngineReady = true;
          });

          for (int i = 0; i < clothingProducts.length; i++) {
            _swipeItems.add(SwipeItem(
              content: clothingProducts[i],
              likeAction: () async {
                bool resp = await APIHelper.postInteraction(
                    clothingProducts[i].id, InteractionType.LIKE);
                if (resp) {
                  _showToast("Liked ${clothingProducts[i].name}",
                      Icons.thumb_up_alt, Colors.green);
                } else {
                  _showToast("Error, Like Failed", Icons.dangerous_outlined,
                      Colors.black);
                }
              },
              nopeAction: () async {
                bool resp = await APIHelper.postInteraction(
                    clothingProducts[i].id, InteractionType.DISLIKE);
                if (resp) {
                  _showToast("Disliked ${clothingProducts[i].name}",
                      Icons.thumb_down_alt, Colors.red);
                } else {
                  _showToast("Error, Dislike Failed", Icons.dangerous_outlined,
                      Colors.black);
                }
              },
              superlikeAction: () async {
                bool resp = await APIHelper.postInteraction(
                    clothingProducts[i].id, InteractionType.ADDTOCART);
                if (resp) {
                  await APIHelper.addToCart(clothingProducts[i].id,
                      clothingProducts[i].variant_id!, 1);

                  _showToast("${clothingProducts[i].name} added to Cart",
                      Icons.shopping_cart, Colors.blue);
                } else {
                  _showToast("Error, Add to Cart Failed",
                      Icons.dangerous_outlined, Colors.black);
                }
              },
            ));
          }
          _matchEngine = MatchEngine(swipeItems: _swipeItems);
          recResults = _swipeItems;
        }
      } else {
        setState(() {
          _matchEngineReady = true;
        });
        if (swiped) {
          recResults.removeRange(0, swipeIndex);
          swiped = false;
        }
        _swipeItems = recResults;
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      }
    } catch (e) {
      print("Error: $e");
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
    return Scaffold(
      body: Stack(
        children: [
          _buildAppBar(),
          Container(
            height: MediaQuery.of(context).size.height,
            child: !_matchEngineReady
                ? Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.black,
                        rightDotColor: Colors.grey,
                        size: 70),
                  )
                : SwipeCards(
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
                            if (!over) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewProductPage(
                                    product: _swipeItems[index].content,
                                  ),
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                over
                                    ? Positioned.fill(
                                        child: Container(
                                        color: Colors.grey,
                                      ))
                                    : Image.network(
                                        _swipeItems[index].content.image,
                                        fit: BoxFit.cover,
                                      ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: over
                                        ? null
                                        : LinearGradient(
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
                                  alignment: over
                                      ? Alignment.center
                                      : Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: over
                                          ? CrossAxisAlignment.center
                                          : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          _swipeItems[index].content.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          _swipeItems[index].content.seller,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
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
                                      over
                                          ? ""
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
                    onStackFinished: () {
                      setState(() {
                        over = true;
                        swipe_allow = false;
                      });
                      recs_over();
                    },
                    itemChanged: (SwipeItem item, int index) {
                      if (!swiped) {
                        swiped = true;
                      }
                      print("item: ${item.content.name}, index: $index");
                      swipeIndex = index;
                      if (index == (_swipeItems.length - 2)) {
                        _swipeItems.removeRange(0, _swipeItems.length - 2);
                        swipeIndex = 0;
                        _fetchRecommendation(true);
                      }
                    },
                    leftSwipeAllowed: swipe_allow, // Like
                    rightSwipeAllowed: swipe_allow, // Dislike
                    upSwipeAllowed: swipe_allow, // Add to Cart
                    fillSpace: true,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      rewind();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/previous.svg',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  Text(
                    "Sling",
                    style: TextStyle(
                      color: appBlack,
                      fontSize: 38.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Aladin',
                    ),
                  ),
                  SizedBox(height: 6.0),
                ],
              ),
            ),
            EaseInWidget(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const FiltersModal();
                  },
                );
              },
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                height: 30.0,
                width: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EaseInWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const EaseInWidget({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
