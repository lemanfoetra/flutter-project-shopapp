import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/Orders.dart';

class OrdersProvider with ChangeNotifier {
  String token;
  OrdersProvider({this.token});

  bool loadOrders = false;
  bool loadProductPaid = false;

  List<Orders> _ordersPaid = [];
  List<Product> _productPaid = [];

  /// get data orders yang sudah paid
  List<Orders> get ordersPaid => [..._ordersPaid];

  /// get list product paid
  List<Product> get productPaid {
    _productPaid.sort((data1, data2) => data1.id.compareTo(data2.id));
    return [..._productPaid];
  }

  /// to enble load productPaid
  void enableLoadProductPaid() {
    loadProductPaid = true;
  }


  /// To disable load productPaid
  void disabledLoadProductPaid(){
    loadProductPaid = false;
  }


  /// get semua orders saya
  Future<List<Product>> getOrders(String date) async {
    if (loadProductPaid) {
      await getOrdersByTime(date)
          .then((response) => getProduct())
          .catchError((error) => print(error.toString()));

      // disable load product paid
      this.disabledLoadProductPaid();
    }
    return productPaid;
  }

  /// get orders by time (date) proses
  /// fungsi ini akan mengisi var List [ordersPaid]
  Future<void> getOrdersByTime(String date) async {
    final url =
        "http://shopapp.ardynsulaeman.com/public/api/orders/paidwhere/$date";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    var responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      if (responseData['status'] == 'success') {
        if ((responseData['data']) != null) {
          var listProduct = responseData['data'] as List<dynamic>;
          if (listProduct.length > 0) {
            List<Orders> newData = [];
            listProduct.forEach((data) {
              var realData = data as Map<String, dynamic>;
              newData.add(
                Orders(
                  id: realData['id'].toString(),
                  products_id: realData['products_id'].toString(),
                  quantity: realData['quantity'].toString(),
                  updated_at: realData['updated_at'],
                ),
              );
            });

            // mengosongkan List ordersPaid lama
            _ordersPaid = [];

            // isi dengan List ordersPaid baru
            _ordersPaid = newData;
          }
        }
      }
    }
  }

  /// get product
  Future<void> getProduct() async {
    // hapus list productPaid lama
    _productPaid = [];

    // ambil list productPaid baru
    if (ordersPaid.length > 0) {
      await Future.wait(
        ordersPaid.map(
          (value) {
            return getProductById(value.products_id);
          },
        ),
      );
    }
  }

  /// get Product by Id
  /// fungsi ini akan mengisi var productPaid
  Future<void> getProductById(String id) async {
    final String url =
        "http://shopapp.ardynsulaeman.com/public/api/product/get/$id";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        responseData['data'].forEach((value) {
          Map<String, dynamic> valueData = value;

          // crate new Product data
          Product newData = Product(
            id: valueData['id'].toString(),
            price: valueData['price'].toDouble(),
            description: valueData['description'],
            image: valueData['img_url'],
            name: valueData['name'],
          );

          // cek apakah product udah ada?
          if (_productPaidIsNotPresent(productPaid, newData.id)) {
            _productPaid.add(newData);
          }
        });
      }
    }
  }

  bool _productPaidIsNotPresent(List<Product> data, String id) {
    bool result = true;
    if (data.length > 0) {
      data.forEach((data) {
        if (data.id == id) {
          result = false;
        }
      });
    }
    return result;
  }
}
