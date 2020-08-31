import 'package:flutter/material.dart';
import 'package:shopapp/screens/add_product.dart';
import './screens/my_product.dart';
import './providers/auth_provider.dart';
import './providers/product_provider.dart';
import './screens/home.dart';
import './screens/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: null,
          update: (ctx, auth, product) => ProductProvider(token: auth.token),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopper',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => auth.isAuth ? HomeScreens() : Login(),
            MyProduct.routeName: (ctx) => MyProduct(),
            AddProduct.routeName: (ctx) => AddProduct(),
          },
        ),
      ),
    );
  }
}
