import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/models/cart.dart';
import 'package:horcrux/models/clothing.dart';
import 'package:horcrux/screens/order_review_screen.dart';
import 'package:horcrux/screens/view_product_page.dart';
import 'package:horcrux/widgets/cart_card.dart';

class CartScreen extends StatefulWidget {
  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<dynamic> results = [];
  double totalPrice = 0;
  bool isLoading = true;
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
      quantity = [];
      maxQuantity = [];
      for (ClothingItem item in results) {
        totalPrice += 1 * double.parse(item.price);
        quantity.add(1);
        maxQuantity.add(item.quantity!);
      }
      setState(() {
        isLoading = false;
      });
      cartAvailable = true;
      localResults = results;
      localTotalPrice = totalPrice;
      localQuantity = quantity;
      localMaxQuantity = maxQuantity;
    } else {
      setState(() {
        results = localResults;
        totalPrice = localTotalPrice;
        quantity = localQuantity;
        maxQuantity = localMaxQuantity;
      });
      getCart(true);
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
        backgroundColor: Colors.white,
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
                        product_id: results[index].id,
                        name: results[index].name,
                        seller: results[index].seller,
                        price: results[index].price,
                        image: results[index].image,
                        quantity: quantity[index],
                        maxQuantity: maxQuantity[index],
                      ),
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

  Widget _buildCard({
    required String product_id,
    required String image,
    required String name,
    required String seller,
    required String price,
    required int quantity,
    required int maxQuantity,
  }) {
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
                  child: Image.asset(
                    image,
                    width: 120,
                    height: 120,
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
                              _updateCartQuantity(product_id, quantity);
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
                                await APIHelper.deleteFromCart(product_id);
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
