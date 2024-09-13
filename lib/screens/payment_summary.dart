import 'package:flutter/material.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sling/screens/order_success.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String address_id;
  final String address;
  final String city_state;
  final String zipCode;
  final String name;
  final List<dynamic> cart;

  const PaymentSummaryScreen(
      {Key? key,
      required this.address_id,
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
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    razorpay.on(Razorpay.eventExternalWallet, handlerExternalWallet);
    razorpay.on(Razorpay.eventPaymentSuccess, handlerPaymentSuccess);
    razorpay.on(Razorpay.eventPaymentError, handlerError);
    setState(() {
      for (Map<String, dynamic> item in widget.cart) {
        totalPrice += double.parse(item['selected_variant'][0]['price']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlePayment() async {
    //TODO update with actual billing address
    Map<String, dynamic> resp =
        await APIHelper.createOrder("661409663abf27dd3c711f16");
    openCheckout(resp["response"]["order_id"], resp["response"]["amount"]);
  }

  void openCheckout(String order_id, int amount) {
    var options = {
      "key": "rzp_test_OnyJBCDukNk4bJ",
      "order_id": order_id,
      "amount": amount,
      // "name": "Sample App",
      // "description": "Payment for the product",
      // "prefill": {
      //   "contact": "8618950413", //"9513388379",
      //   "email": "smaran.jawalkar@gmail.com",
      // },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print("RAZORPAY ERROR");
      print(e.toString());
    }
  }

  void handlerError(PaymentFailureResponse response) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Payment failed"),
            content: Text(
                "Transaction failed. Please try again\nError: ${response.message}"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    print('Payment error');
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print('External Wallet');
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    var resp = APIHelper.verifyOrder(
        response.paymentId!, response.orderId!, response.signature!);
    print(resp);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OrderSuccess()));
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
                              itemCount: widget.cart.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.cart[index]['title'],
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
                                      '₹${widget.cart[index]['selected_variant'][0]['price']}',
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
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: widget.cart.length,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Expanded(
                            //           child: Text(
                            //             widget.cart[index]['shop'][0]['name'],
                            //             style: TextStyle(
                            //               fontSize: 14.0,
                            //               fontWeight: FontWeight.w500,
                            //               color: Colors.grey[700],
                            //             ),
                            //           ),
                            //         ),
                            //         Text(
                            //           '₹${(index+1) * 7}',
                            //           softWrap: true,
                            //           textAlign: TextAlign.right,
                            //           style: TextStyle(
                            //             fontSize: 12.0,
                            //             color: Colors.grey[600],
                            //           ),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // )
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
                          var resp =
                              await APIHelper.createOrder(widget.address_id);
                          if (resp['success'] == true) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => OrderSuccessScreen(
                                      address: widget.address,
                                      city_state: widget.city_state,
                                      zipCode: widget.zipCode,
                                      name: widget.name,
                                      cart: widget.cart)),
                            );
                            openCheckout(resp["response"]["order_id"],
                                resp["response"]["amount"]);
                          }
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
