import 'package:flutter/material.dart';
import '../screens/my_product.dart';

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
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
          Divider(),
          Container(
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('My Product'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(MyProduct.routeName);
              },
            ),
          ),
          Divider(),

        ],
      ),
    );
  }
}