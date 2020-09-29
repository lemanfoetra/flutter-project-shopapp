import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/Cart.dart';

class CartProvider with ChangeNotifier {
  String token;
  List<Cart> _cart;

  CartProvider({this.token});


  /// get list cart
  List<Cart> get cart{
    return [..._cart];
  }


  /// get data cart in server
  Future<void> myCart() async {
    final String url = 'http://shopapp.ardynsulaeman.com/public/api/orders';
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    var responseDecode = jsonDecode(response.body) as Map<String, dynamic>;
    if (responseDecode['status'] == 'success') {
      var responseData = responseDecode['data'] as Map<String, dynamic>;
      var data = responseData['data'] as List<dynamic>;
      if (data.length > 0) {
        List<Cart> newCart = [];
        data.forEach((value) {
          var valueEach = value as Map<String, dynamic>;
          newCart.add(
            Cart(
              id: valueEach['id'].toString(),
              status: valueEach['status'],
              productsId: valueEach['products_id'].toString(),
              quantity: valueEach['quantity'].toInt(),
              usersId: valueEach['users_id'].toString(),
            ),
          );
        });
        _cart = newCart;
        notifyListeners();
      }
    }
  }
}
