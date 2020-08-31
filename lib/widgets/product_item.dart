import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  ProductItem({this.name, this.price, this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: InkWell(
        onTap: () {},
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
              ),
            ),
            footer: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black45,
              child: Column(
                children: <Widget>[
                  Text(name, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
                  SizedBox(height: 3),
                  Text("Rp $price", style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            // footer: GridTileBar(
            //   backgroundColor: Colors.black26,
            //   title: Text(name),
            //   subtitle: Text("Rp $price"),
            // ),
          ),
        ),
      ),
    );
  }
}
