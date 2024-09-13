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

List<Order> orders = [
  Order(
    id: '1',
    products: [
      ClothingItem(
        id: '1',
        name: 'Summer Floral Dress',
        price: 2399.0,
        seller: 'Fashion Empire',
        image: 'assets/1.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Striped Button-Up Shirt',
        price: 1399.0,
        seller: 'Trendy Styles',
        image: 'assets/2.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Classic Skinny Jeans',
        price: 2799.0,
        seller: 'Denim Dreams',
        image: 'assets/4.avif',
      ),
    ],
    quantity: [1, 1],
    address: '123 Main St, City',
    userId: 'user123',
    orderedAt: 'March 5, 2024',
    status: 1,
    totalPrice: 2399.0 + 1399.0,
  ),
  Order(
    id: '2',
    products: [
      ClothingItem(
        id: '1',
        name: 'Denim Mini Skirt',
        price: 1799.0,
        seller: 'Chic Boutique',
        image: 'assets/3.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Classic Skinny Jeans',
        price: 2799.0,
        seller: 'Denim Dreams',
        image: 'assets/4.avif',
      ),
    ],
    quantity: [1, 1],
    address: '456 Oak Ave, Town',
    userId: 'user456',
    orderedAt: 'March 10, 2024',
    status: 2,
    totalPrice: 1799.0 + 2799.0,
  ),
  Order(
    id: '3',
    products: [
      ClothingItem(
        id: '1',
        name: 'Faux Leather Moto Jacket',
        price: 3699.0,
        seller: 'Urban Outfit',
        image: 'assets/5.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Off-Shoulder Crop Top',
        price: 999.0,
        seller: 'Style Haven',
        image: 'assets/6.avif',
      ),
    ],
    quantity: [1, 1],
    address: '789 Elm St, Village',
    userId: 'user789',
    orderedAt: 'March 5, 2024',
    status: 0,
    totalPrice: 3699.0 + 999.0,
  ),
  Order(
    id: '4',
    products: [
      ClothingItem(
        id: '1',
        name: 'Floral Maxi Dress',
        price: 2999.0,
        seller: 'Elegant Fashion',
        image: 'assets/7.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Printed T-Shirt',
        price: 899.0,
        seller: 'Graphic Tees Co.',
        image: 'assets/8.avif',
      ),
    ],
    quantity: [1, 1],
    address: '123 Elm St, City',
    userId: 'user123',
    orderedAt: 'March 5, 2024',
    status: 1,
    totalPrice: 2999.0 + 899.0,
  ),
  Order(
    id: '5',
    products: [
      ClothingItem(
        id: '1',
        name: 'Skinny Fit Jeans',
        price: 2499.0,
        seller: 'Urban Denim',
        image: 'assets/9.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Plaid Wool Blazer',
        price: 3299.0,
        seller: 'Fashion Forward',
        image: 'assets/10.avif',
      ),
    ],
    quantity: [1, 1],
    address: '456 Oak Ave, Town',
    userId: 'user456',
    orderedAt: 'March 5, 2024',
    status: 2,
    totalPrice: 2499.0 + 3299.0,
  ),
  Order(
    id: '6',
    products: [
      ClothingItem(
        id: '1',
        name: 'Casual Striped Shirt',
        price: 1499.0,
        seller: 'Trendy Threads',
        image: 'assets/11.avif',
      ),
      ClothingItem(
        id: '1',
        name: 'Cargo Shorts',
        price: 1199.0,
        seller: 'Active Wear Co.',
        image: 'assets/12.avif',
      ),
    ],
    quantity: [1, 1],
    address: '789 Maple St, Village',
    userId: 'user789',
    orderedAt: 'March 5, 2024',
    status: 0,
    totalPrice: 1499.0 + 1199.0,
  ),
];
