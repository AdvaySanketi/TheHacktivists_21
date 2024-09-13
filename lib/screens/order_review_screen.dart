import 'package:flutter/material.dart';
import 'package:sling/api/APIHelper.dart';
import 'package:sling/appTheme.dart';
import 'package:sling/models/address.dart';
import 'package:sling/models/clothing.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sling/screens/payment_summary.dart';
import '../widgets/cart_card.dart';

class OrderReviewScreen extends StatefulWidget {
  final List<dynamic> results;

  const OrderReviewScreen({Key? key, required this.results}) : super(key: key);

  @override
  _OrderReviewScreenState createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  int _current = 0;
  List<dynamic> results = [];
  List<Address> addresses = [];
  String _selectedAddress = '';
  bool _newAdd = false;
  int _selectedIndex = 0;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCart();
    getAddresses();
  }

  void getCart() {
    setState(() {
      results = widget.results;
    });
  }

  void getAddresses() async {
    var resp = await APIHelper.getAddresses();
    setState(() {
      addresses = resp['response'].toList();
      if (addresses.isEmpty) {
        _newAdd = true;
      } else {
        _selectedAddress =
            '${addresses[0].address}, ${addresses[0].city}, ${addresses[0].state}, ${addresses[0].pincode}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Review',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
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
                items: results.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SliderCard(
                        name: item['title'],
                        quantity: item['quantity'],
                        price: item['allVariants'][0]['price'],
                        image: item['product_preview'][0],
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: results.map((item) {
                  int index = results.indexOf(item);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? appBlack : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20), // Gap between sections
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter Discount Code',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            borderSide: BorderSide(color: appGrey),
                          )),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Apply button logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appBlack,
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Gap between sections
              Text(
                'Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Gap between sections
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(color: appGrey),
                    )),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(color: appGrey),
                    )),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(color: appGrey),
                    )),
              ),
              SizedBox(height: 20), // Gap between sections
              Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15), // Gap between sections
              if (addresses.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: DropdownButton<String>(
                          value: _selectedAddress,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedAddress = newValue!;
                              _selectedIndex = addresses.indexWhere((address) =>
                                  '${address.address}, ${address.city}, ${address.state}, ${address.pincode}' ==
                                  newValue);
                            });
                          },
                          isExpanded: true,
                          itemHeight: 80,
                          items: addresses
                              .map<DropdownMenuItem<String>>((Address address) {
                            return DropdownMenuItem<String>(
                              value:
                                  '${address.address}, ${address.city}, ${address.state}, ${address.pincode}',
                              child: Text(
                                '${address.address}, ${address.city}, ${address.state}, ${address.pincode}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                                softWrap: true,
                              ),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          underline: SizedBox(),
                          iconSize: 0,
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          elevation: 16,
                          style: TextStyle(color: appBlack),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _newAdd = !_newAdd;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBlack,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Add New Address',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )),

              if (_newAdd)
                Column(children: [
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                        hintText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: appGrey),
                        )),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                        hintText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: appGrey),
                        )),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: stateController,
                          decoration: InputDecoration(
                              hintText: 'State',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(color: appGrey),
                              )),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: zipCodeController,
                          decoration: InputDecoration(
                              hintText: 'ZipCode',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(color: appGrey),
                              )),
                        ),
                      ),
                    ],
                  ),
                ]),
              SizedBox(height: 30), // Gap between sections
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please fill in all the required fields.'),
                              duration: Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        } else {
                          if (_newAdd) {
                            if (addressController.text.isNotEmpty ||
                                cityController.text.isNotEmpty ||
                                stateController.text.isNotEmpty ||
                                zipCodeController.text.isNotEmpty ||
                                phoneController.text.isNotEmpty ||
                                nameController.text.isNotEmpty ||
                                emailController.text.isNotEmpty) {
                              var resp = await APIHelper.createAddress(Address(
                                  address: addressController.text,
                                  city: cityController.text,
                                  state: stateController.text,
                                  pincode: zipCodeController.text,
                                  phone: phoneController.text));
                              if (resp['success'] == true) {
                                String city_state =
                                    '${cityController.text}, ${stateController.text}';
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => PaymentSummaryScreen(
                                          address_id: resp['response'].id,
                                          address: addressController.text,
                                          city_state: city_state,
                                          zipCode: zipCodeController.text,
                                          name: nameController.text,
                                          cart: results,
                                        )));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please fill in all the required fields.'),
                                  duration: Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PaymentSummaryScreen(
                                      address_id: addresses[_selectedIndex].id!,
                                      address:
                                          addresses[_selectedIndex].address,
                                      city_state:
                                          '${addresses[_selectedIndex].city}, ${addresses[_selectedIndex].state}',
                                      zipCode:
                                          addresses[_selectedIndex].pincode,
                                      name: nameController.text,
                                      cart: results,
                                    )));
                          }
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
                        'Payment Summary',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
