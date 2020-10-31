import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/overview_detail_screen.dart';
import '../models/product.dart';
import '../widgets/order_item.dart';
import '../providers/orders_provider.dart';

class OrdersScreenItem extends StatefulWidget {
  static const routeName = "/ordersScreenItem";

  @override
  _OrdersScreenItemState createState() => _OrdersScreenItemState();
}

class _OrdersScreenItemState extends State<OrdersScreenItem> {
  OrdersProvider get _ordersProvNotListen {
    return Provider.of<OrdersProvider>(context, listen: false);
  }

  @override
  void initState() {
    _ordersProvNotListen.loadProductPaid = true;
    super.initState();
  }

  /// mengubah date ke bentuk string dengan format yang bisa di tentukan
  String dateReal(DateTime date) {
    final DateFormat formater = DateFormat('dd MMMM y');
    return formater.format(date);
  }

  /// navigate to detail product
  void openDetailProduct(String id, BuildContext context) {
    Navigator.of(context).pushNamed(OverViewDetailScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // merupakan date yang diparsing dari orders_list
    final date = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Oders Tanggal ${this.dateReal(DateTime.parse(date))}',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .getOrders(date),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            } else if (snapshot.hasData) {
              List<Product> products = snapshot.data;
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (contex, index) {
                  Product product = products[index];
                  return OrderItem(
                    id: product.id,
                    name: product.name.toString(),
                    price: product.price,
                    image: product.image,
                    navigateTo: (id) {
                      this.openDetailProduct(id, context);
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }
}
