import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProductItem extends StatelessWidget {
  final String image;
  final String title;
  final double price;

  MyProductItem({
    @required this.image,
    @required this.title,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 0.5,
                color: Colors.grey,
              ),
            ),
            child: FadeInImage(
              image: NetworkImage(image),
              placeholder: AssetImage('assets/images/picture.png'),
              fit: BoxFit.cover,
            ),
          ),
          header: Container(
            // padding: EdgeInsets.only(
            //   top: 7,
            //   right: 3,
            // ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, right: 8),
                    child: Icon(
                      FontAwesomeIcons.ellipsisV,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Edit')),
                    PopupMenuItem(child: Text('Hapus')),
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
    );
  }
}
