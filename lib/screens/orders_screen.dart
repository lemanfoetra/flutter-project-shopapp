import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_list_provider.dart';
import '../screens/ordersitem_screen.dart';
import '../widgets/orders_list.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  /// ordersListProvider Listen False
  OrdersListProvider get _ordersListProviderNotListen {
    return Provider.of<OrdersListProvider>(context, listen: false);
  }

  /// ordersListProvider with Listen
  OrdersListProvider get _ordersListProviderWithListen {
    return Provider.of<OrdersListProvider>(context);
  }

  @override
  void initState() {
    // when init state call, enable load orderslist
    _ordersListProviderNotListen.enableLoadOrdersList();
    super.initState();
  }

  /// navigate to OrdersItemPaid
  void navigateToItem(String date) {
    Navigator.of(context)
        .pushNamed(OrdersScreenItem.routeName, arguments: date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Sukses'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: RefreshIndicator(
          displacement: 20,
          onRefresh: () => _ordersListProviderNotListen.onRefreshScreen(),
          child: FutureBuilder(
            future: _ordersListProviderWithListen.fetchOrdersList(),
            builder: (ctx, cart) {
              if (cart.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (cart.hasError) {
                return Center(
                  child: Text(cart.error.toString()),
                );
              } else if (cart.hasData) {
                List<dynamic> data = cart.data;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    Map<String, dynamic> dataValue = data[index];
                    return OrdersList(
                      date: DateTime.parse(dataValue['DATE']),
                      routeTo: (date) => this.navigateToItem(date),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('tidak ada data'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
