import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/productCart.dart';
import '../models/Cart.dart';

class CartProvider with ChangeNotifier {
  double _totalPrice = 0;
  String token;
  List<Cart> _cart = [];
  List<ProductCart> _productOrders = [];

  CartProvider({this.token});

  /// get list cart
  List<Cart> get cart {
    return [..._cart];
  }

  /// get list product cart
  List<ProductCart> get productOrders {
    if (_productOrders.length > 0)
      _productOrders.sort((a, b) => a.id.compareTo(b.id));
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
        _cart = newCart;
      } else {
        _cart = [];
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
    if (cart.length > 0) {
      await Future.wait(
          cart.map((value) => getProduct(value.productsId, value.quantity)));
    }
    setTotalPrice();
  }

  /// GET product with id in server
  Future<void> getProduct(String productId, int quantity) async {
    final String url =
        "http://shopapp.ardynsulaeman.com/public/api/product/get/$productId";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    var responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (responseData['status'] == 'success') {
      List<ProductCart> newData = [];
      var data = responseData['data'] as List<dynamic>;
      data.forEach(
        (value) {
          var dataValue = value as Map<String, dynamic>;
          newData.add(
            ProductCart(
              id: dataValue['id'].toString(),
              name: dataValue['name'],
              price: dataValue['price'].toDouble(),
              description: dataValue['description'],
              image: dataValue['img_url'],
              quantity: quantity,
            ),
          );
        },
      );
      _productOrders.addAll(newData);
    }
  }

  // Add cart To server
  Future<void> addCart(String productId, int quantity) async {
    final String url = 'http://shopapp.ardynsulaeman.com/public/api/orders';
    final response = await http.post(
      url,
      body: {'products_id': productId, 'quantity': quantity.toString()},
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final responseStatus = json.decode(response.body) as Map<String, dynamic>;
      if (responseStatus['status'] != 'success') {
        throw responseStatus['message'].toString();
      }
      Cart _lastCart = _cart.firstWhere((data) => data.productsId == productId);
      Cart newCart = Cart(
        id: _lastCart.id,
        status: _lastCart.status,
        quantity: (_lastCart.quantity + quantity),
        usersId: _lastCart.usersId,
        productsId: _lastCart.productsId,
      );
      _cart[_cart.indexOf(_lastCart)] = newCart;
      setNewQuantityProductCart(productId, newCart.quantity);
    }
    notifyListeners();
  }

  /// Kurangi quantity of cart
  Future<void> unlistCart(String productId) async {
    final String url =
        'http://shopapp.ardynsulaeman.com/public/api/orders/unlist/$productId';
    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final responseStatus = json.decode(response.body) as Map<String, dynamic>;
      if (responseStatus['status'] != 'success') {
        throw responseStatus['message'].toString();
      }
    }
    Cart _lastCart = _cart.firstWhere((data) => data.productsId == productId);
    Cart newCart = Cart(
      id: _lastCart.id,
      status: _lastCart.status,
      quantity: (_lastCart.quantity > 0 ? (_lastCart.quantity - 1) : 0),
      usersId: _lastCart.usersId,
      productsId: _lastCart.productsId,
    );
    if (_lastCart.quantity > 0) {
      _cart[_cart.indexOf(_lastCart)] = newCart;
    }
    setNewQuantityProductCart(productId, newCart.quantity);
    notifyListeners();
  }

  /// Get total price cart
  double get getTotalPrice => _totalPrice;

  /// set total price cart
  void setTotalPrice() {
    double total = 0;
    if (productOrders.length > 0) {
      productOrders.forEach((value) {
        total += (value.price.toDouble() * value.quantity);
      });
    }
    _totalPrice = total;
    notifyListeners();
  }

  /// Set new Quantity
  void setNewQuantityProductCart(String productId, int newQuantity) {
    ProductCart lastData =
        _productOrders.firstWhere((data) => data.id == productId);
    ProductCart newData = ProductCart(
      id: lastData.id,
      name: lastData.name,
      price: lastData.price,
      description: lastData.description,
      image: lastData.image,
      quantity: newQuantity,
    );
    _productOrders[_productOrders.indexOf(lastData)] = newData;
  }

  /// Set my chart to paid
  Future<void> prosesCart() async {
    final url = "http://shopapp.ardynsulaeman.com/public/api/orders/proses";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    var responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if(responseData['status'] == 'success'){
      _productOrders = [];
    }else{
      throw 'Proses Gagal';
    }
    notifyListeners();
  }
}
