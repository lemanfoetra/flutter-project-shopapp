import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class OverViewDetailScreen extends StatefulWidget {
  static const routeName = '/product-overview-detail-screen';

  @override
  _OverViewDetailScreenState createState() => _OverViewDetailScreenState();
}

class _OverViewDetailScreenState extends State<OverViewDetailScreen> {
  /// ProductProvider objek
  ProductProvider _productProvider({bool listen = false}) {
    return Provider.of<ProductProvider>(context, listen: listen);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// mengambil argumant dari screen sebelumnya
    String productId = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: _productProvider().fetchProduct(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _onNullData();
        } else if (snapshot.hasError) {
          return _onNullData(message: snapshot.error.toString());
        } else if (snapshot.hasData) {
          // tampung data
          Product product = snapshot.data;
          return _bodyScreen(product);
        } else {
          return _onNullData(message: 'Tidak ada data');
        }
      },
    );
  }

  /// widget yang dipanggil ketika data null atau exception
  /// akan menampilkan Widget loading jika tidak ada pesan yang dimasukan
  Widget _onNullData({String message}) {
    return Scaffold(
      appBar: AppBar(title: Text('....')),
      body: Container(
        color: Colors.white,
        child: message == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text(message),
              ),
      ),
    );
  }

  /// widget body screen
  Widget _bodyScreen(Product product) {
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
            ],
          );
        },
      ),
    );
  }
}
