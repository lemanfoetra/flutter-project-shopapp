

import 'package:flutter/cupertino.dart';

class Cart {

  final String id;
  final String status;
  final int quantity;
  final String usersId;
  final String productsId;

  Cart({
    @required this.id,
    @required this.status,
    @required this.quantity,
    @required this.usersId,
    @required this.productsId,
  });
}
