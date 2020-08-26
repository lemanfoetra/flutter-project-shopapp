

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {


  /// Function untuk submitProduct
  Future<void> submitProduct( String name, String price, String description, String image) async {
    final url =  Uri.parse('http://shopapp.ardynsulaeman.com/public/api/product/add');

    final response = await http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['price'] = price
      ..fields['description'] = description
      ..files.add(
        await http.MultipartFile.fromPath('image', image)
      );
  }

}