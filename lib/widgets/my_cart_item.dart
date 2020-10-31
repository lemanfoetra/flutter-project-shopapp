import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';

class MyCartItem extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final Function navigateTo;
  final int quantity;
  Function addCart;
  Function removeCart;

  MyCartItem({
    this.id,
    this.name,
    this.price,
    this.description,
    this.image,
    this.navigateTo,
    this.quantity,
    this.addCart,
    this.removeCart,
  });

  @override
  _MyCartItemState createState() => _MyCartItemState();
}

class _MyCartItemState extends State<MyCartItem> {
  int quantity = 1;

  /// Add Quantity
  void addQuantity(String productId) {
    try {
      widget.addCart(productId);
      setState(() {
        quantity += 1;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// Kurangi quantity
  void kurangiQuantity(String productId) {
    try {
      widget.removeCart(productId);
      if (quantity > 0) {
        setState(() {
          quantity -= 1;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    quantity = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Container(
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rp ${widget.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 40,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        addQuantity(widget.id);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Color(0xFFf5a25d),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$quantity",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        kurangiQuantity(widget.id);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                          child: Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
