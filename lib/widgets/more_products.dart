import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';
import 'package:sling/screens/view_product_page.dart';
import 'package:sling/widgets/product_card.dart';
import 'package:flutter/material.dart';

class MoreProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 8.0),
              child: Text(
                'More products',
                style: TextStyle(
                    color: appBlack,
                    shadows: [
                      BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(0, 3),
                          blurRadius: 6)
                    ],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: 250,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  return Padding(
                      padding: index == 0
                          ? EdgeInsets.only(left: 24.0, right: 8.0)
                          : index == 4
                              ? EdgeInsets.only(right: 24.0, left: 8.0)
                              : EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                          onTap: () {}, child: ProductCard(products[index])));
                },
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ));
  }
}
