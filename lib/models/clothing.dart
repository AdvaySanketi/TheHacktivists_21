import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:swipe_cards/swipe_cards.dart';

class ClothingItem {
  final String id;
  final String name;
  final String price;
  final String seller;
  final String image;
  final List<String>? images;
  final String? variant_id;

  ClothingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.seller,
    required this.image,
    this.images,
    this.variant_id,
  });
}

List<SwipeItem> recResults = [];
bool swiped = false;
int swipeIndex = 0;
bool over = false;

final List<ClothingItem> products = [
  ClothingItem(
    id: '1',
    name: "Summer Floral Dress",
    price: '2399.0',
    seller: "Fashion Empire",
    image: "assets/_1.avif",
  ),
  ClothingItem(
    id: '2',
    name: "Striped Button-Up Shirt",
    price: '1399.0',
    seller: "Trendy Styles",
    image: "assets/_2.avif",
  ),
  ClothingItem(
    id: '3',
    name: "Denim Mini Skirt",
    price: '1799.0',
    seller: "Chic Boutique",
    image: "assets/_3.avif",
  ),
  ClothingItem(
    id: '4',
    name: "Classic Skinny Jeans",
    price: '2799.0',
    seller: "Denim Dreams",
    image: "assets/_4.avif",
  ),
  ClothingItem(
    id: '5',
    name: "Faux Leather Moto Jacket",
    price: '3699.0',
    seller: "Urban Outfit",
    image: "assets/_5.avif",
  ),
  ClothingItem(
    id: '6',
    name: "Off-Shoulder Crop Top",
    price: '999.0',
    seller: "Style Haven",
    image: "assets/_6.avif",
  ),
  ClothingItem(
    id: '1',
    name: "Summer Floral Dress",
    price: '2399.0',
    seller: "Fashion Empire",
    image: "assets/_1.avif",
  ),
  ClothingItem(
    id: '2',
    name: "Striped Button-Up Shirt",
    price: '1399.0',
    seller: "Trendy Styles",
    image: "assets/_2.avif",
  ),
  ClothingItem(
    id: '3',
    name: "Denim Mini Skirt",
    price: '1799.0',
    seller: "Chic Boutique",
    image: "assets/_3.avif",
  ),
  ClothingItem(
    id: '4',
    name: "Classic Skinny Jeans",
    price: '2799.0',
    seller: "Denim Dreams",
    image: "assets/_4.avif",
  ),
  ClothingItem(
    id: '5',
    name: "Faux Leather Moto Jacket",
    price: '3699.0',
    seller: "Urban Outfit",
    image: "assets/_5.avif",
  ),
  ClothingItem(
    id: '6',
    name: "Off-Shoulder Crop Top",
    price: '999.0',
    seller: "Style Haven",
    image: "assets/_6.avif",
  ),
];
