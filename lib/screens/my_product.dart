import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shopapp/models/product.dart';
import '../widgets/my_product_item.dart';
import '../widgets/drawer.dart';
import '../widgets/form_product.dart';
import './add_product.dart';
import '../providers/my_product_provider.dart';

class MyProduct extends StatefulWidget {
  static const routeName = '/my_product';

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  bool _firstLoad = true;
  List<Product> _myProduct = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    if (_firstLoad) {
      load();
    }
    super.didChangeDependencies();
  }

  /// load my product
  Future<void> load() async {
    var myProduct = Provider.of<MyProductProvider>(context, listen: false);
    await myProduct.load();
    setState(() {
      _myProduct = myProduct.myProduct;
      _firstLoad = false;
    });
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  /// load more my product
  Future<void> more() async {
    var myProduct = Provider.of<MyProductProvider>(context, listen: false);
    await myProduct.loadMore();
    if (_myProduct.length == myProduct.myProduct.length) {
      _refreshController.loadNoData();
    } else {
      setState(() {
        _myProduct = myProduct.myProduct;
      });
      _refreshController.loadComplete();
    }
  }


  /// remove product
  Future<void> _removeProduct(String id) async {
    var myProduct = Provider.of<MyProductProvider>(context, listen: false);
    await myProduct.removeProduct(id);
    print('1 ${_myProduct.length}');
    print('2 ${myProduct.myProduct.length}');
    setState(() {
      _myProduct = myProduct.myProduct;
    });
  }



  void _editProduct(String id){
    print("edit $id");
  }

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
      body: _firstLoad
          ? Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () => load(),
              onLoading: () => more(),
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
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
                itemCount: _myProduct.length,
                itemBuilder: (context, index) {
                  return MyProductItem(
                    id: _myProduct[index].id.toString(),
                    image: _myProduct[index].image,
                    price: _myProduct[index].price,
                    title: _myProduct[index].name,
                    remove: _removeProduct,
                    edit: _editProduct,
                  );
                },
              ),
            ),
    );
  }
}
