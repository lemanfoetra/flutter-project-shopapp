import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class OverViewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';

  @override
  _OverViewScreenState createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  /// untuk menampilkan status loading
  bool isLoading = false;

  /// Add new cart
  Future<void> submitCart(
      BuildContext context, String productId, int quantity) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<CartProvider>(context, listen: false)
          .addCart(productId, quantity);
      _alert(context, 'Berhasil ditambahkan ke cart');
    } catch (error) {
      _alert(context, error.toString());
    }
    setState(() {
      isLoading = false;
    });
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
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.black45,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.fitHeight,
                          colorBlendMode: BlendMode.colorBurn,
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 15),
                        width: double.infinity,
                        child: Text(
                          "Rp ${product.price.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(
                                'Deskripsi Produk',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              width: double.infinity,
                              child: Text(
                                product.description,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                padding:
                    EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        color: Colors.orange,
                        textColor: Colors.white,
                        onPressed: () {
                          submitCart(context, productId, 1);
                        },
                        child: isLoading
                            ? Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : Text(
                                '+ Cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
