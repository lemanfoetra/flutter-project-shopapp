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
  double totalPrice = 0;

  // overview product
  void navigateTo(String id) {
    Navigator.of(context).pushNamed(OverViewScreen.routeName, arguments: id);
  }

  /// Add Cart
  Future<void> addCart(String productId) async {
    try {
      var cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.addCart(productId, 1);
      cartProvider.setTotalPrice();
    } catch (e) {
      throw e.toString();
    }
  }

  /// Remove quantity of Cart
  Future<void> removeCart(String productId) async {
    try {
      var cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.unlistCart(productId);
      cartProvider.setTotalPrice();
    } catch (e) {
      throw e.toString();
    }
  }

  /// Proses Cart
  Future<void> prosesCart() async {
    try {
      await Provider.of<CartProvider>(context, listen: false).prosesCart();
      setState(() {
        totalPrice = 0;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Saya'),
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
                builder: (ctx, cart, ch) => Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.productOrders.length,
                        itemBuilder: (ctx, index) {
                          var productCart = cart.productOrders[index];
                          return MyCartItem(
                            id: productCart.id,
                            description: productCart.description,
                            image: productCart.image,
                            name: productCart.name,
                            price: productCart.price,
                            quantity: productCart.quantity,
                            navigateTo: (id) => navigateTo(id),
                            addCart: (idProduct) => addCart(idProduct),
                            removeCart: (idProduct) => removeCart(idProduct),
                          );
                        },
                      ),
                    ),
                    _prosesCart(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _prosesCart() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 2),
          )
        ],
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Total",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 25,
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Rp',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (ctx, cart, ch) => Text(
                    cart.getTotalPrice.toStringAsFixed(0).toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 3, right: 10),
            child: InkWell(
              onTap: () => prosesCart(),
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFf5a25d),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Proses',
                  style: TextStyle(
                    color: Color(0xFFfa7f72),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
