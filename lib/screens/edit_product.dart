import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/form_product.dart';
import '../providers/my_product_provider.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatelessWidget {
  static const routeName = '/edit_product';

  @override
  Widget build(BuildContext context) {
    String idProduct = ModalRoute.of(context).settings.arguments as String;
    Product product =
        Provider.of<MyProductProvider>(context).getDataProduct(idProduct);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Builder(
        builder: (builderContext) => FormProduct(
          productId: product.id,
          imageUrl: product.image,
          name: product.name,
          description: product.description,
          price: product.price.toString(),
          functionOnSubmit: (name, price, description, image) async {
            try {
              await Provider.of<MyProductProvider>(context).submitEditProduct(
                idProduct,
                name,
                price,
                description,
                image,
              );
            } catch (error) {
              throw error;
            }
          },
        ),
      ),
    );
  }
}
