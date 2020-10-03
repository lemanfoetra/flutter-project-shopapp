import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/Cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  String token;
  List<Cart> _cart;
  List<Product> _productOrders = [];

  CartProvider({this.token});

  /// get list cart
  List<Cart> get cart {
    return [..._cart];
  }

  /// get list product cart
  List<Product> get productOrders {
    return [..._productOrders];
  }

  /// get data cart in server
  Future<void> getOrdersFromServer() async {
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
        data.forEach(
          (value) {
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
          },
        );
        // insert new cart
        _cart = newCart;
        print('response 1');
      }
    }
  }


  Future<void> setMyOrders() async {
    await getOrdersFromServer()
        .then((response) => setProductOrders())
        .catchError((error) {
      debugPrint(error.toString());
    });
  }


  // set data productOrders List
  Future<void> setProductOrders() async {
    _productOrders = [];
    await Future.wait(
      cart.map((value) => getProduct(value.productsId))
    );
  }

  /// GET product with id in server
  Future<void> getProduct(String productId) async {
    final String url =
        "http://shopapp.ardynsulaeman.com/public/api/product/get/$productId";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    var responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (responseData['status'] == 'success') {
      List<Product> newData = [];
      var data = responseData['data'] as List<dynamic>;
      data.forEach(
        (value) {
          var dataValue = value as Map<String, dynamic>;
          newData.add(Product(
            id: dataValue['id'].toString(),
            name: dataValue['name'],
            price: dataValue['price'].toDouble(),
            description: dataValue['description'],
            image: dataValue['img_url'],
          ),);
        },
      );
      _productOrders.addAll(newData);
    }
  }
}
