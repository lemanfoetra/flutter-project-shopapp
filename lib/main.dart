import 'package:flutter/material.dart';
import './screens/overview_detail_screen.dart';
import './providers/orders_list_provider.dart';
import './screens/ordersitem_screen.dart';
import './providers/orders_provider.dart';
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
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: null,
          update: (ctx, auth, order) => OrdersProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersListProvider>(
          create: null,
          update: (ctx, auth, orderList) =>
              OrdersListProvider(token: auth.token),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx)=> routeTo(auth, HomeScreens()),
            
            MyProduct.routeName: (ctx) => routeTo(auth, MyProduct()),
            AddProduct.routeName: (ctx) => routeTo(auth, AddProduct()),
            EditProduct.routeName: (ctx) => routeTo(auth, EditProduct()),
            OverViewScreen.routeName: (ctx) => routeTo(auth, OverViewScreen()),
            OrdersScreen.routeName: (ctx) => routeTo(auth, OrdersScreen()),
            CartScreen.routeName: (ctx) => routeTo(auth, CartScreen()),
            OrdersScreenItem.routeName: (ctx) =>
                routeTo(auth, OrdersScreenItem()),
            OverViewDetailScreen.routeName: (ctx) =>
                routeTo(auth, OverViewDetailScreen()),
          },
        ),
      ),
    );
  }

  // pengecekan auth
  Widget routeTo(AuthProvider auth, Widget className) {
    if (auth.isAuth) {
      return className;
    }
    return FutureBuilder(
      future: auth.tryLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error));
        } else {
          return Login();
        }
      },
    );
  }
}
