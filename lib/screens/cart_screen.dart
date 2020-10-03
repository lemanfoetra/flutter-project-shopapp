import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/widgets/my_cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/drawer.dart';
import '../screens/overview_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // overview product
  void navigateTo(String id) {
    Navigator.of(context).pushNamed(OverViewScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Carts'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: FutureBuilder(
          future:
              Provider.of<CartProvider>(context, listen: false).setMyOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return Center(
                child: Text('Upps.. terjadi kesalahan ${snapshot.error}'),
              );
            } else {
              return Consumer<CartProvider>(
                builder: (ctx, cartProvider, child) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: cartProvider.productOrders.length,
                  itemBuilder: (ctx, index) {
                    var productCart = cartProvider.productOrders[index];
                    return MyCartItem(
                      id: productCart.id,
                      description: productCart.description,
                      image: productCart.image,
                      name: productCart.name,
                      price: productCart.price,
                      navigateTo: (id) => navigateTo(id),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
