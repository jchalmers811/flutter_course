import 'package:flutter/material.dart';

class Product {
  // final prevents products from being edited outside of update product method
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavourite;

  final String userEmail; // email of user who created product
  final String userId; // id of user who created

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavourite = false});
}
