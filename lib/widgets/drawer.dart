import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/my_product.dart';
import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            AppBar(
              title : Text('Menu')
            ),
            SizedBox(height: 10),
            Container(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.shoppingBag,
                  color: Color(0xFFfa7f72),
                  size: 20,
                ),
                title: Text('Produk'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
            Divider(),
            Container(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.thList,
                  color: Color(0xFFfa7f72),
                  size: 20,
                ),
                title: Text('Produk Saya'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(MyProduct.routeName);
                },
              ),
            ),
            Divider(),
            Container(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.cartArrowDown,
                  color: Color(0xFFfa7f72),
                  size: 20,
                ),
                title: Text('Keranjang Saya'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(CartScreen.routeName);
                },
              ),
            ),
            Divider(),
            Container(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.luggageCart,
                  color: Color(0xFFfa7f72),
                  size: 20,
                ),
                title: Text('Order Sukses'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
            ),
            Divider(),
            Container(
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Color(0xFFfa7f72),
                  size: 20,
                ),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
                  Provider.of<AuthProvider>(context).logout();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
