import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final Function navigationToOverview;

  ProductItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    @required this.navigationToOverview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: InkWell(
        onTap: () => navigationToOverview(id),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.3,
                ),
              ),
              child: FadeInImage(
                image: NetworkImage(imageUrl),
                placeholder: AssetImage('assets/images/loading.gif'),
                fit: BoxFit.cover,
              ),
            ),
            footer: Container(
              padding: EdgeInsets.only(top: 5, right: 3, left: 3, bottom: 8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      name,
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
