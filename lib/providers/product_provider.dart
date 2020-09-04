import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/product.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';

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

  /// Function untuk submitProduct
  Future<void> submitProduct(
    String name,
    String price,
    String description,
    String image,
  ) async {
    try {
      final url =
          Uri.parse('http://shopapp.ardynsulaeman.com/public/api/product/add');

      final response = http.MultipartRequest('POST', url);
      response.headers['Accept'] = 'application/json';
      response.headers['Authorization'] = "Bearer $token";
      response.fields['name'] = name;
      response.fields['price'] = price;
      response.fields['description'] = description;
      response.files.add(await http.MultipartFile.fromPath('image', image));
      final result = await response.send();
      if (result.statusCode != 200) {
        throw 'Gagal Menyimpan.';
      }
    } catch (error) {
      throw error.toString();
    }
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

      // set url to next product
      if(responseData['links']['next'] != null && responseData['links']['next'] != 'null'){
        _nextUrlLoadProduct = responseData['links']['next'];
      }

      List<Product> newData = [];
      if (responseData['data'] != null) {
        var _listHasil = responseData['data'] as List<dynamic>;

        for (int i = 0; i < _listHasil.length; i++) {
          newData.add(Product(
            name: _listHasil[i]['name'],
            price: _listHasil[i]['price'].toDouble(),
            description: _listHasil[i]['description'],
            image: _listHasil[i]['img_url'],
          ));
        }
        _listProduct = newData;
      }
    } catch (error) {
      throw "Gagal Menyambung ke server";
    }
    notifyListeners();
  }

  /// set url to load next list of product
  void setUrlToNextLoadListProduct(defaultUrl, nextUrl) {
    if (nextUrl == null || nextUrl == 'null') {
      _nextUrlLoadProduct = defaultUrl;
    }
    print(nextUrl);
    _nextUrlLoadProduct = nextUrl;
  }

  /// Loading old data
  Future<void> loadNextListProductFromServer() async {
    //try {
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

      if(responseData['links']['next'] != null && responseData['links']['next'] != 'null'){
        _nextUrlLoadProduct = responseData['links']['next'];
      }


      List<Product> newData = [];
      if (responseData['data'] != null) {
        var _listHasil = responseData['data'] as List<dynamic>;

        for (int i = 0; i < _listHasil.length; i++) {
          newData.add(Product(
            name: _listHasil[i]['name'],
            price: _listHasil[i]['price'].toDouble(),
            description: _listHasil[i]['description'],
            image: _listHasil[i]['img_url'],
          ));
        }
        print(newData);
        _listProduct.addAll(newData);

        print(_listProduct);
      }
    // } catch (error) {
    //   throw "Gagal Menyambung ke server";
    // }
    notifyListeners();
  }

  void bersihkanItem() {
    _listProduct = [];
    notifyListeners();
  }
}
