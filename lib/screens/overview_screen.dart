import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class OverViewScreen extends StatelessWidget {
  static const routeName = '/product-overview-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<ProductProvider>(context).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.name),
              background: Container(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Container(
                child: Text(
                  "Rp ${product.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 800),
            ]),
          )
        ],
      ),
    );
  }
}
