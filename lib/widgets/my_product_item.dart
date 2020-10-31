import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProductItem extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final double price;
  final Function remove;
  final Function edit;
  final Function navigatorOverview;

  MyProductItem({
    @required this.id,
    @required this.image,
    @required this.title,
    @required this.price,
    @required this.remove,
    @required this.edit,
    @required this.navigatorOverview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () => navigatorOverview(id),
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey,
                ),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              ),
            ),
            header: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    onSelected: (jenis) {
                      if (jenis == 'remove') remove(id);
                      if (jenis == 'edit') edit(id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        FontAwesomeIcons.ellipsisV,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('Hapus'),
                        value: 'remove',
                      ),
                    ],
                  )
                ],
              ),
            ),
            footer: Container(
              padding: EdgeInsets.only(top: 5, right: 3, left: 3, bottom: 8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Container(
                    child: Text(
                      "Rp $price",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
