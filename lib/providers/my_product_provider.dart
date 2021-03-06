import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class MyProductProvider with ChangeNotifier {
  String token;
  List<Product> _myProduct = [];
  String _urlLoad = 'http://shopapp.ardynsulaeman.com/public/api/product/get';
  String _urlLoadNext;

  MyProductProvider({this.token});

  /// get list my product
  List<Product> get myProduct {
    return [..._myProduct];
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

  /// Function untuk submit Edit Product
  Future<void> submitEditProduct(
    String id,
    String name,
    String price,
    String description,
    String image,
  ) async {
    try {
      final url = Uri.parse(
          'http://shopapp.ardynsulaeman.com/public/api/product/edit/' + id);
      Map<String, dynamic> body = {
        'name': name,
        'price': price,
        'description': description
      };

      final response = http.MultipartRequest('POST', url);
      response.headers['Accept'] = 'application/json';
      response.headers['Authorization'] = "Bearer $token";
      response.fields['name'] = name;
      response.fields['price'] = price;
      response.fields['description'] = description;

      if (image != null) {
        response.files.add(await http.MultipartFile.fromPath('image', image));
      }
      final result = await response.send();

      print(result.statusCode);
      if (result.statusCode != 200) {
        throw 'Gagal mengupdate.';
      }

    } catch (error) {
      throw error.toString();
    }
  }

  /// load my product
  Future<void> load() async {
    final response = await http.get(_urlLoad, headers: {
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    });

    var responseData = json.decode(response.body) as Map<String, dynamic>;

    // cek token dan status
    if (responseData != null) {
      if (responseData['status'] != 'success') {
        throw responseData['status'];
      }
    }

    List<Product> newData = [];
    if (responseData['data'] != null) {
      var dataResponse = responseData['data'] as Map<String, dynamic>;
      if (dataResponse != null) {
        var data = dataResponse['data'] as List<dynamic>;
        if (data != null) {
          for (var i = 0; i < data.length; i++) {
            newData.add(
              Product(
                id: data[i]['id'].toString(),
                name: data[i]['name'],
                price: data[i]['price'].toDouble(),
                description: data[i]['description'],
                image: data[i]['img_url'],
              ),
            );
          }
        }

        /// set next url
        _urlLoadNext = setNextUrl(_urlLoad, dataResponse['next_page_url']);
      }
    }
    _myProduct = newData;
    notifyListeners();
  }

  /// load more product
  Future<void> loadMore() async {
    if (_urlLoadNext != null) {
      final response = await http.get(_urlLoadNext, headers: {
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      });

      var responseData = json.decode(response.body) as Map<String, dynamic>;

      // cek token dan status
      if (responseData != null) {
        if (responseData['status'] != 'success') {
          throw responseData['status'];
        }
      }

      List<Product> newData = [];
      if (responseData['data'] != null) {
        var dataResponse = responseData['data'] as Map<String, dynamic>;
        if (dataResponse != null) {
          var data = dataResponse['data'] as List<dynamic>;
          if (data != null) {
            for (var i = 0; i < data.length; i++) {
              newData.add(
                Product(
                  id: data[i]['id'].toString(),
                  name: data[i]['name'],
                  price: data[i]['price'].toDouble(),
                  description: data[i]['description'],
                  image: data[i]['img_url'],
                ),
              );
            }
          }

          /// set next url
          _urlLoadNext =
              setNextUrl(_urlLoadNext, dataResponse['next_page_url']);
        }
      }
      _myProduct.addAll(newData);
      notifyListeners();
    }
  }

  /// Hapus product
  Future<void> removeProduct(String id) async {
    String _url = 'http://shopapp.ardynsulaeman.com/public/api/product/$id';
    final response = await http.delete(_url, headers: {
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    });

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    // hapus list product di lokal
    if (responseData['status'] == 'success') {
      _myProduct.removeWhere((product) => product.id == id);
    }
    notifyListeners();
  }

  /// get data Product
  Product getDataProduct(String id) {
    return myProduct.firstWhere((product) => product.id == id);
  }

  /// set next Url
  String setNextUrl(String currentUrl, String nextUrl) {
    if (nextUrl == null) {
      return null;
    }
    if (currentUrl == nextUrl) {
      return null;
    }
    return nextUrl;
  }
}
