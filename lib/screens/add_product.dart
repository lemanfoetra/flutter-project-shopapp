import 'package:flutter/material.dart';
import '../widgets/form_product.dart';
import '../providers/my_product_provider.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatelessWidget {
  static const routeName = '/add_product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Product')),
      body: Builder(
        builder: (builderContext) => FormProduct(
          functionOnSubmit: (name, price, description, image) async {
            try {
              await Provider.of<MyProductProvider>(context)
                  .submitProduct(name, price, description, image);
            } catch (error) {
              throw error;
            }
          },
        ),
      ),
    );
  }
}
