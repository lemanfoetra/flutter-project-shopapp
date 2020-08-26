import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/form_product.dart';
import './add_product.dart';

class MyProduct extends StatelessWidget {
  static const routeName = '/my_product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Product'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProduct.routeName);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
      
      ),
    );
  }
}
