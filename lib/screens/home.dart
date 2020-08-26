import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class HomeScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopper'),
      ),   
      drawer: AppDrawer(),   
      body: Container(
        child: Center(
          child: Text('Welcome to Shpper App'),
        ),
      ),
    );
  }
}