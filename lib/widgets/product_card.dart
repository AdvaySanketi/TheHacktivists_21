import 'package:sling/appTheme.dart';
import 'package:sling/models/clothing.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ClothingItem product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: null,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            height: 1000,
            width: MediaQuery.of(context).size.width / 2 - 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xfffbd085).withOpacity(0.46),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
                // Content overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: appBlack,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Center(
                        child: Text(
                      product.name,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
