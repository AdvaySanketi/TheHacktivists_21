import 'dart:convert';

import 'clothing.dart';

class Order {
  final String id;
  final List<ClothingItem> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final String orderedAt;
  final int status;
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products,
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}
