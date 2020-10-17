import 'package:flutter/cupertino.dart';

class ProductCart {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final int quantity;

  ProductCart({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.description,
    @required this.image,
    @required this.quantity,
  });
}
