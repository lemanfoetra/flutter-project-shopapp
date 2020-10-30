import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String id;
  final double price;
  final String name;
  final String image;
  final Function navigateTo;

  OrderItem({
    this.id,
    this.price,
    this.navigateTo,
    this.name,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => navigateTo(id),
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          'Rp ${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
