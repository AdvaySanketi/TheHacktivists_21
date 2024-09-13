import 'package:sling/models/clothing.dart';
import 'package:flutter/material.dart';

class ProductOption extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ClothingItem product;
  const ProductOption(
    this.scaffoldKey, {
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Image.asset(
          product.image,
          fit: BoxFit.cover,
        ),
      ),
    );
    // Positioned(
    //   right: 0.0,
    //   left: 180.0,
    // child:
    //       ],
    //     ),
    //   ),
    // )
  }
}
