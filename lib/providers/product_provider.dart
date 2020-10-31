import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/product.dart';
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  String token;
  List<Product> _listProduct = [];
  String _urlLoadProduct =
      'http://shopapp.ardynsulaeman.com/public/api/product';
  String _nextUrlLoadProduct = '';

  ProductProvider({this.token});

  /// Get list product
  List<Product> get listProducts {
    return [..._listProduct];
  }

  /// Load List Product dari server
  Future<void> loadListProductFromServer() async {
    try {
      final response = await http.get(_urlLoadProduct, headers: {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      });

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      // cek token
      if (responseData != null) {
        if (responseData['status'] == 'Token is Invalid') {
          throw "Token is Invalid";
        }
      }

      List<Product> newData = [];
      if (responseData['data'] != null) {
        var _listHasil = responseData['data'] as List<dynamic>;

        for (int i = 0; i < _listHasil.length; i++) {
          newData.add(Product(
            id: _listHasil[i]['id'].toString(),
            name: _listHasil[i]['name'],
            price: _listHasil[i]['price'].toDouble(),
            description: _listHasil[i]['description'],
            image: _listHasil[i]['img_url'],
          ));
        }
        _listProduct = newData;
        this.setUrlToNextLoadListProduct(
          _urlLoadProduct,
          responseData['links']['next'],
        );
      }
    } catch (error) {
      throw "Gagal Menyambung ke server";
    }
    notifyListeners();
  }

  /// Loading old data
  Future<void> loadNextListProductFromServer() async {
    try {
      if (_nextUrlLoadProduct != '' && _nextUrlLoadProduct != null) {
        final response = await http.get(_nextUrlLoadProduct, headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        });

        final responseData = json.decode(response.body) as Map<String, dynamic>;

        // cek token
        if (responseData != null) {
          if (responseData['status'] == 'Token is Invalid') {
            throw "Token is Invalid";
          }
        }

        List<Product> newData = [];
        if (responseData['data'] != null) {
          var _listHasil = responseData['data'] as List<dynamic>;

          for (int i = 0; i < _listHasil.length; i++) {
            newData.add(Product(
              id: _listHasil[i]['id'].toString(),
              name: _listHasil[i]['name'],
              price: _listHasil[i]['price'].toDouble(),
              description: _listHasil[i]['description'],
              image: _listHasil[i]['img_url'],
            ));
          }
          _listProduct.addAll(newData);
          this.setUrlToNextLoadListProduct(
              _nextUrlLoadProduct, responseData['links']['next']);
        }
      }
    } catch (error) {
      throw "Gagal Menyambung ke server";
    }
    notifyListeners();
  }

  /// set url to load next list of product
  void setUrlToNextLoadListProduct(defaultUrl, nextUrl) {
    if (nextUrl == null || nextUrl == 'null') {
      _nextUrlLoadProduct = '';
    } else if (_nextUrlLoadProduct == nextUrl) {
      _nextUrlLoadProduct = '';
    }
    _nextUrlLoadProduct = nextUrl;
  }

  void bersihkanItem() {
    _listProduct = [];
    notifyListeners();
  }

  /// Mencari produk berdasarkan id
  Product findById(String id) {
    return _listProduct.firstWhere((product) => product.id == id);
  }



  /// Get Product from server with id
  Future<Product> fetchProduct(String id) async {
    final String url =
        "http://shopapp.ardynsulaeman.com/public/api/product/get/$id";
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        Product _product;
        responseData['data'].forEach(
          (value) {
            Map<String, dynamic> valueData = value;
            // crate new Product data
            _product = Product(
              id: valueData['id'].toString(),
              price: valueData['price'].toDouble(),
              description: valueData['description'],
              image: valueData['img_url'],
              name: valueData['name'],
            );
          },
        );
        return _product;
      }
    }
    return null;
  }
}
