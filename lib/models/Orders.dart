import 'package:flutter/cupertino.dart';

class Orders {
  final String id;
  final String quantity;
  final String products_id;
  final String updated_at;

  Orders({
    @required this.id,
    @required this.quantity,
    @required this.products_id,
    @required this.updated_at,
  });
}