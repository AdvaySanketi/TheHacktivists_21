import 'package:flutter/material.dart';
import 'package:horcrux/api/APIHelper.dart';
import 'package:horcrux/appTheme.dart';
import 'package:horcrux/screens/cart_screen.dart';

class CardItem extends StatelessWidget {
  final String id;
  final String name;
  final String seller;
  final String image;
  final String price;
  final int quantity;

  CardItem(
      {required this.id,
      required this.name,
      required this.seller,
      required this.image,
      required this.price,
      required this.quantity});

  GlobalKey<CartScreenState> csKey = GlobalKey<CartScreenState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$seller - ₹$price',
                    style: TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 1, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: DropdownButton<String>(
                            value: 'S',
                            onChanged: (newValue) {},
                            items: ['S', 'M', 'L', 'XL']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            underline: SizedBox(),
                            iconSize: 20,
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            elevation: 16,
                            style: TextStyle(color: appBlack),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton<String>(
                            value: 'Blue',
                            onChanged: (newValue) {},
                            items: ['Red', 'Blue', 'Black', 'Green']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.length > 7
                                    ? value.substring(0, 7)
                                    : value),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            underline: SizedBox(),
                            iconSize: 20,
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            elevation: 16,
                            style: TextStyle(color: appBlack),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {},
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {},
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          color: Colors.grey[100],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () async {
                            await APIHelper.deleteFromCart(id);
                            // csKey.currentState!.test();
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
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderCard extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final int quantity;

  SliderCard(
      {required this.name,
      required this.image,
      required this.price,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 120,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Price: ₹$price',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('3-5 Days', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
