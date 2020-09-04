import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoading(),
        enablePullUp: true,
        enablePullDown: true,
        header: CustomHeader(
          builder: (context, status) {
            String sts;
            if (status == RefreshStatus.idle) {
              sts = "Tarik untuk memuat";
            } else if (status == RefreshStatus.failed) {
              sts = "Gagal Memuat";
            } else if (status == RefreshStatus.refreshing) {
              sts = "Sedang Memuat";
            } else if (status == RefreshStatus.completed) {
              sts = "Selesai Memuat";
            } else {
              sts = "Tidak ada lagi data";
            }
            return Text("$sts");
          },
        ),
        footer: CustomFooter(
          builder: (context, status) {
            String text;
            if (status == LoadStatus.idle) {
              text = "Tarik untuk memuat";
            } else if (status == LoadStatus.loading) {
              text = "Memuat data";
            } else {
              text = "Tidak ada lagi data";
            }
            return Text("$text");
          },
        ),
        child: ListView.builder(
          itemBuilder: (c, i) {
            return Card(child: Center(child: Text(items[i])));
          },
          itemCount: items.length,
          itemExtent: 100.0,
        ),
      ),
    );
  }
}
