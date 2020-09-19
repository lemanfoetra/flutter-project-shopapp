import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/overview_screen.dart';
import '../widgets/product_item.dart';
import '../widgets/drawer.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  bool _isFirstLoaded = true;
  List<Product> listProduct = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// Untuk laod data baru dan refresh halaman
  Future<void> _refreshHalaman() async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadListProductFromServer();
    setState(() {
      listProduct = productProvider.listProducts;
      _isFirstLoaded = false;
    });
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  /// Load More data
  Future<void> _onLoadMore() async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadNextListProductFromServer();
    if (listProduct.length < productProvider.listProducts.length) {
      setState(() {
        listProduct = productProvider.listProducts;
      });
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  /// Untuk membuka halaman detail product
  void navigationToOverview(String id) {
    Navigator.of(context).pushNamed(OverViewScreen.routeName, arguments: id);
  }

  /// Auto load on page opened
  @override
  void didChangeDependencies() {
    if (_isFirstLoaded) {
      _refreshHalaman();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopper'),
      ),
      drawer: AppDrawer(),
      body: _isFirstLoaded
          ? Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () => _refreshHalaman(),
              onLoading: () => _onLoadMore(),
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                ),
                itemCount: listProduct.length,
                itemBuilder: (context, index) {
                  String imageUrl = listProduct[index].image;
                  return ProductItem(
                    id: listProduct[index].id,
                    name: listProduct[index].name,
                    price: listProduct[index].price,
                    description: listProduct[index].description,
                    imageUrl: imageUrl,
                    navigationToOverview: (id) => navigationToOverview(id),
                  );
                },
              ),
            ),
    );
  }
}
