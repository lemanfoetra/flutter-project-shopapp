import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class OverViewScreen extends StatelessWidget {
  static const routeName = '/product-overview-screen';

  /// Add new cart
  Future<void> submitCart(
      BuildContext context, String productId, int quantity) async {
    try {
      await Provider.of<CartProvider>(context, listen: false)
          .addCart(productId, quantity);
      _alert(context, 'Berhasil ditambahkan ke cart');
    } catch (error) {
      _alert(context, error.toString());
    }
  }

  /// Alert snackbar
  void _alert(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<ProductProvider>(context).findById(productId);

    return Scaffold(
      body: Builder(
        builder: (context) => CustomScrollView(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Rp ${product.price}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      FlatButton(
                        onPressed: () {
                          submitCart(context, productId, 1);
                        },
                        child: Icon(FontAwesomeIcons.cartPlus),
                      ),
                    ],
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
      ),
    );
  }
}
