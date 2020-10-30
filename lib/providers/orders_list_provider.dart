import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrdersListProvider with ChangeNotifier {
  String token;
  List<dynamic> _ordersList = [];
  bool loadOrdersList = false;

  OrdersListProvider({this.token});

  /// get ordersList
  List<dynamic> get ordersList => [..._ordersList];

  /// to enble load ordersList
  void enableLoadOrdersList() {
    loadOrdersList = true;
  }

  /// To disable load ordersList
  void disableLoadOrdersList() {
    loadOrdersList = false;
  }


  /// ketika screen di refresh
  Future<void> onRefreshScreen() async{
    enableLoadOrdersList();
    notifyListeners();
  }

  /// async mengambil semua data orders paid dari server
  Future<List<dynamic>> fetchOrdersList() async {
    if (loadOrdersList) {
      final url = "http://shopapp.ardynsulaeman.com/public/api/orders/paidat";
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
        },
      );
      var responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (responseData['data'] != null) {
          var data = responseData['data'] as Map<String, dynamic>;
          if (data['data'] != null) {
            _ordersList = data['data'] as List<dynamic>;

            // setelah selesai, nonaktifkan load ordersList
            this.disableLoadOrdersList();
          }
        }
      }
    }
    return ordersList;
  }
}
