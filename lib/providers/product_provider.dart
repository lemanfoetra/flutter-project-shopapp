import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  String token;

  ProductProvider({this.token});

  /// Function untuk submitProduct
  Future<bool> submitProduct(
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
}
