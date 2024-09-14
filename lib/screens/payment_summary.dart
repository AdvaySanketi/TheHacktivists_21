import 'package:flutter/material.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/models/clothing.dart';
import 'package:horcrux/screens/order_success.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String address;
  final String city_state;
  final String zipCode;
  final String name;
  final List<dynamic> cart;

  const PaymentSummaryScreen(
      {Key? key,
      required this.address,
      required this.city_state,
      required this.zipCode,
      required this.name,
      required this.cart})
      : super(key: key);

  @override
  _PaymentSummaryScreenState createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  double totalPrice = 0.0;
  List<dynamic> cart = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      cart = widget.cart;
      for (ClothingItem item in cart) {
        totalPrice += double.parse(item.price);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Payment Summary',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(16.0),
                        child: Column(children: [
                          Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Subtotal:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '₹$totalPrice',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600]),
                                  ),
                                ]),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cart[index].name,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '₹${cart[index].price}',
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Shipping:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '₹100',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600]),
                                  ),
                                ]),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cart[index].seller,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '₹${(index + 1) * 7}',
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Taxes:',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₹${0.18 * totalPrice}',
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₹${totalPrice + 199}',
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ]),
                        ]))),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Deliver to:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey[600]),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address:',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700]),
                              ),
                              Container(
                                  width: 200,
                                  child: Text(
                                    widget.address,
                                    softWrap: true,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey[600]),
                                  )),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'City/State:',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                widget.city_state,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[600]),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Zip Code:',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700]),
                              ),
                              Text(
                                widget.zipCode,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey[600]),
                              ),
                            ]),
                      ])),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Returns:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Returns are valid for 30 days after an order is recieved. Returns are processed by each individual brand, and it is at the discretion of each brand to accept or deny any returns. We do not manage returns individually.',
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.grey[600]),
                          )
                        ]),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // var resp =
                          //     await APIHelper.createOrder(widget.address_id);
                          // if (resp['success'] == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => OrderSuccessScreen(
                                    address: widget.address,
                                    city_state: widget.city_state,
                                    zipCode: widget.zipCode,
                                    name: widget.name,
                                    cart: cart)),
                          );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBlack,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Proceed to Payment',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
