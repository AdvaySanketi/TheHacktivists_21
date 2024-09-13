import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/widgets/more_products.dart';
import 'package:input_quantity/input_quantity.dart';

class ViewProductPage extends StatefulWidget {
  final ClothingItem product;

  ViewProductPage({required this.product});

  @override
  _ViewProductPageState createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<CarouselSliderState> _carouselKey = GlobalKey();

  int active = 0;
  int _currentQuantity = 1;
  String price = '';
  String? _selectedVariant;
  List<dynamic>? images;
  int _current = 0;
  String cartText = "Add to Cart";
  List<dynamic> options = [];
  List<dynamic> variants = [];
  String desc = "";
  late List<String> _dropdownValues;
  int quantity = 0;
  bool liked = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    price = widget.product.price;
    images = widget.product.images;
    getProduct(widget.product.id);
  }

  void getProduct(String product_id) async {
    var resp = await APIHelper.getProduct(product_id);
    List<dynamic> results = resp['response'].toList();
    setState(() {
      desc = results[0]['body'];

      variants = results[0]['variants'];

      images = results[0]['productImages'];

      liked = results[0]['isInWishList'];

      if (variants.length > 1) {
        options = results[0]['options'];
      }

      _dropdownValues =
          List.generate(options.length, (index) => options[index]['values'][0]);

      _findVariant(_dropdownValues, variants);
    });
  }

  void _findVariant(List<String> _dropdownValues, List<dynamic> variants) {
    for (var variant in variants) {
      bool match = true;
      for (int index = 0; index < _dropdownValues.length; index++) {
        String optionKey = 'option${index + 1}';
        if (variant[optionKey] != _dropdownValues[index]) {
          match = false;
          break;
        }
      }
      if (match) {
        setState(() {
          _selectedVariant = variant['id'];
          quantity = variant['inventoryQuantity'];

          if (quantity == 0) {
            cartText = "Item Sold Out";
          } else if (quantity < _currentQuantity) {
            _currentQuantity = quantity;
          }

          price = variant['price'];
          if (variant['variant_image'] != null) {
            images!.remove(variant['variant_image']);
            images!.insert(0, variant['variant_image']);
          }
        });
        resetCarousel();
      }
    }
  }

  void resetCarousel() {
    _carouselKey.currentState!.pageController!.jumpToPage(0);
    setState(() {
      _current = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget description = GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              desc,
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(color: appBlack),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: [
                    CarouselSlider(
                      key: _carouselKey,
                      options: CarouselOptions(
                        height: 380,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: images!.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    if (images!.length > 1)
                      Positioned(
                        top: 355,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                            ignoring: true,
                            child: Center(
                              child: Container(
                                width: 25.0 * images!.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: images!.map((item) {
                                    int index = images!.indexOf(item);
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current == index
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )),
                      ),
                    Positioned(
                      top: 30,
                      left: 7,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all<CircleBorder>(
                            CircleBorder(),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appBlack,
                                fontSize: 22,
                              ),
                            ),
                            Stack(
                              children: [
                                RawMaterialButton(
                                  onPressed: () async {
                                    if (!liked) {
                                      bool resp =
                                          await APIHelper.postInteraction(
                                              widget.product.id,
                                              InteractionType.LIKE);
                                      if (resp) {
                                        setState(() {
                                          liked = true;
                                        });
                                      } else {
                                        print("Error liking the Product");
                                      }
                                    } else {
                                      var result =
                                          await APIHelper.deleteFromWishlist(
                                              widget.product.id);
                                      if (result['success']) {
                                        setState(() {
                                          liked = false;
                                        });
                                      } else {
                                        print("Error disliking the Product");
                                      }
                                    }
                                  },
                                  constraints: BoxConstraints(
                                    minWidth: 45,
                                    minHeight: 45,
                                  ),
                                  child: Icon(
                                    liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: liked ? Colors.red : appBlack,
                                  ),
                                  elevation: 0.0,
                                  shape: CircleBorder(),
                                  fillColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.product.seller,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: appBlack,
                            fontSize: 16,
                          ),
                        ),
                        desc.isNotEmpty
                            ? description
                            : SizedBox(
                                height: 15,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            options.length,
                            (index) => Row(
                              children: [
                                Text(
                                  '${options[index]['name']}  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: DropdownButton<String>(
                                    value: _dropdownValues[index],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _dropdownValues[index] = newValue!;
                                      });
                                      _findVariant(_dropdownValues, variants);
                                    },
                                    items: options[index]['values']
                                        .map<DropdownMenuItem<String>>(
                                          (value) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                        )
                                        .toList(),
                                    underline: SizedBox(),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: appBlack),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Qty  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                InputQty(
                                  decoration: QtyDecorationProps(
                                      isBordered: false,
                                      borderShape: BorderShapeBtn.circle,
                                      width: 12,
                                      btnColor: Colors.black),
                                  maxVal: quantity,
                                  initVal: 1,
                                  minVal: 1,
                                  steps: 1,
                                  onQtyChanged: (val) {
                                    setState(() {
                                      if (val.toInt() <= quantity) {
                                        _currentQuantity = val.toInt();
                                      }
                                    });
                                  },
                                  qtyFormProps:
                                      QtyFormProps(enableTyping: false),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  MoreProducts(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₹$price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  SizedBox(
                    width: 28.0,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (quantity > 0) {
                          await APIHelper.addToCart(widget.product.id,
                              _selectedVariant!, _currentQuantity);

                          setState(() {
                            cartText = "Added to Cart";
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(appBlack),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        ),
                      ),
                      child: Text(
                        cartText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
