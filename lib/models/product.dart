import 'package:flutter/cupertino.dart';

class Product {

  final String   id;
  final String name;
  final double price;
  final String description;
  final String image;


  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.description,
    @required this.image
  });

}