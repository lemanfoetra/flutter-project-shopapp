import 'package:flutter/material.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/overview_screen.dart';
import './screens/edit_product.dart';
import './providers/my_product_provider.dart';
import './screens/add_product.dart';
import './screens/my_product.dart';
import './providers/auth_provider.dart';
import './providers/product_provider.dart';
import 'screens/home.dart';
import './screens/login.dart';
import 'package:provider/provider.dart';
import './providers/cart_provider.dart';

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
        ChangeNotifierProxyProvider<AuthProvider, MyProductProvider>(
          create: null,
          update: (ctx, auth, myProduct) =>
              MyProductProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: null,
          update: (ctx, auth, cartProvider) => CartProvider(token: auth.token),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopper',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) {
              if (auth.isAuth) {
                return HomeScreens();
              }
              return FutureBuilder(
                future: auth.tryLogin(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        body: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error));
                  } else {
                    return Login();
                  }
                },
              );
            },
            MyProduct.routeName: (ctx) => routeTo(auth.isAuth, MyProduct()),
            AddProduct.routeName: (ctx) => routeTo(auth.isAuth, AddProduct()),
            EditProduct.routeName: (ctx) => routeTo(auth.isAuth, EditProduct() ),
            OverViewScreen.routeName: (ctx) => routeTo(auth.isAuth, OverViewScreen()  ),
            OrdersScreen.routeName: (ctx) => routeTo(auth.isAuth,  OrdersScreen()),
            CartScreen.routeName: (ctx) => routeTo(auth.isAuth, CartScreen()),
          },
        ),
      ),
    );
  }

  // pengecekan auth
  Widget routeTo(bool isAuth, Widget className) {
    if (isAuth) {
      return className;
    }
    return Login();
  }
}
