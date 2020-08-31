import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/product_item.dart';
import '../widgets/drawer.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopper'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false)
            .loadListProductFromServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Text('error ${snapshot.error}');
          } else {
            return Consumer<ProductProvider>(
              builder: (ctx, productProvider, chidl) {
                return Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: productProvider.listProducts.length,
                    itemBuilder: (context, index) {
                      String imageUrl =
                          productProvider.listProducts[index].image;
                      return ProductItem(
                        name: productProvider.listProducts[index].name,
                        price: productProvider.listProducts[index].price,
                        description:
                            productProvider.listProducts[index].description,
                        imageUrl: imageUrl,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
