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
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Product'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('My Product'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(MyProduct.routeName);
              },
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.cartPlus),
              title: Text('My Cart'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
              },
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.firstOrder),
              title: Text('My Orders'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context).logout();
              },
            ),
          )
        ],
      ),
    );
  }
}
