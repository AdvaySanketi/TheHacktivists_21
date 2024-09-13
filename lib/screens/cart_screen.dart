import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/cart.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/screens/order_review_screen.dart';
import 'package:sling/screens/view_product_page.dart';
import 'package:sling/widgets/cart_card.dart';

class CartScreen extends StatefulWidget {
  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<dynamic> results = [];
  double totalPrice = 0;
  List<List<dynamic>> options = [];
  List<List<dynamic>> variants = [];
  bool isLoading = true;
  List<List<String>> dropdownValues = [];
  List<int> quantity = [];
  List<int> maxQuantity = [];

  @override
  void initState() {
    getCart(false);
    super.initState();
  }

  void getCart(bool check) async {
    if (!cartAvailable || check) {
      var resp = await APIHelper.getCart();
      setState(() {
        results = resp['response'].toList();
        totalPrice = 0;
      });
      variants = [];
      options = [];
      quantity = [];
      maxQuantity = [];
      for (Map<String, dynamic> item in results) {
        totalPrice += item['quantity'] *
            double.parse(item['selected_variant'][0]['price']);
        variants.add(item['allVariants']);
        options.add(item['options']);
        quantity.add(item['quantity']);
        maxQuantity.add(item['inventoryQuantity']);
      }
      dropdownValues = List.generate(
          options.length,
          (index1) => List.generate(
              options[index1].length,
              (index2) => results[index1]['selected_variant'][0]['title']
                  .split(' / ')[index2]));
      setState(() {
        isLoading = false;
      });
      cartAvailable = true;
      localResults = results;
      localTotalPrice = totalPrice;
      localOptions = options;
      localVariants = variants;
      localDropdownValues = dropdownValues;
      localQuantity = quantity;
      localMaxQuantity = maxQuantity;
    } else {
      setState(() {
        results = localResults;
        totalPrice = localTotalPrice;
        variants = localVariants;
        options = localOptions;
        dropdownValues = localDropdownValues;
        quantity = localQuantity;
        maxQuantity = localMaxQuantity;
      });
      getCart(true);
    }
  }

  void _updateCartVariant(
      List<String> _dropdownValues, List<dynamic> variants, String id) async {
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
        print(variant['title']);
        var resp = await APIHelper.updateCart(id, variant['id']);
        print(resp['response']);
      }
    }
  }

  void _updateCartQuantity(String id, int quantity) async {
    var resp = await APIHelper.updateCart(id, quantity);
    print(resp['response']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          width: 0,
        ),
        leadingWidth: 0.0,
        title: Center(
          child: Text(
            'My Cart',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.black,
                  rightDotColor: Colors.grey,
                  size: 70),
            )
          : results.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Cart is Empty :(',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Try adding some products.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      _buildCard(
                          id: results[index]['_id'],
                          product_id: results[index]['product_id'],
                          name: results[index]['title'],
                          seller: results[index]['shop'][0]['name'],
                          price: results[index]['selected_variant'][0]['price'],
                          image: results[index]['product_preview'][0],
                          quantity: quantity[index],
                          maxQuantity: maxQuantity[index],
                          options: options[index],
                          variants: variants[index],
                          dropdownValues: dropdownValues[index]),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Color(0xFFEFEFEF),
                          thickness: 1,
                        ),
                      ),
                    ]);
                  },
                ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${totalPrice}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 28.0,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (results.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => OrderReviewScreen(
                                results: results,
                              )),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBlack,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Proceed to Checkout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String id,
      required String product_id,
      required String image,
      required String name,
      required String seller,
      required String price,
      required int quantity,
      required int maxQuantity,
      required List<dynamic> options,
      required List<dynamic> variants,
      required List<String> dropdownValues}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewProductPage(
                product: ClothingItem(
                  id: product_id,
                  name: name,
                  seller: seller,
                  price: price,
                  image: image,
                  images: [image, image, image],
                ),
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    image,
                    width: 120,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$seller - ₹$price',
                        style: TextStyle(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          options.length,
                          (index) => Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValues[index],
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValues[index] = newValue!;
                                });
                                _updateCartVariant(
                                    dropdownValues, variants, id);
                                getCart(true);
                              },
                              items: options[index]['values']
                                  .map<DropdownMenuItem<String>>(
                                    (value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              dropdownColor: Colors.white,
                              underline: SizedBox(),
                              icon: Icon(Icons.keyboard_arrow_down_outlined),
                              iconSize: 20,
                              elevation: 16,
                              style: TextStyle(color: appBlack),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          InputQty(
                            decoration: QtyDecorationProps(
                              isBordered: false,
                              borderShape: BorderShapeBtn.circle,
                              width: 10,
                              btnColor: appGrey,
                            ),
                            maxVal: maxQuantity,
                            initVal: quantity,
                            minVal: 1,
                            steps: 1,
                            onQtyChanged: (val) {
                              setState(() {
                                quantity = val.toInt();
                              });
                              _updateCartQuantity(id, quantity);
                              getCart(true);
                            },
                            qtyFormProps: QtyFormProps(enableTyping: false),
                          ),
                          Spacer(),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              color: Colors.grey[100],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: Colors.grey),
                              onPressed: () async {
                                await APIHelper.deleteFromCart(id);
                                getCart(true);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_shipping,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text('Expected: 3-5 Days',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
