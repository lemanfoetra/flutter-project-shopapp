import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/drawer.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Carts'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: FutureBuilder(
          future: Provider.of<CartProvider>(context).myCart(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if(snapshot.error != null){
              return Center(child: Text('Upps.. terjadi kesalahan'),);
            } else {
              return Text('Done');
            }
          },
        ),
      ),
    );
  }
}
