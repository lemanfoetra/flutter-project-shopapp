import 'package:flutter/material.dart';

class MyCartItem extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final Function navigateTo;

  MyCartItem(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.image,
      this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: InkWell(
            onTap: () {
              navigateTo(id);
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height: 50,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rp $price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
