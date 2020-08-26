import 'package:flutter/material.dart';
import '../widgets/form_product.dart';

class AddProduct extends StatelessWidget {

  static const routeName = '/add_product';


  /// Add product 
  void addProduct(String name, String price, String description, String imgPath){
    print(name);
    print(price);
    print(description);
    print(imgPath);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Product')),
      body: FormProduct(
          functionOnSubmit: addProduct,
      ),
    );
  }
}
