import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrdersList extends StatelessWidget {
  final DateTime date;
  final Function routeTo;

  OrdersList({@required this.date, @required this.routeTo});

  /// mengubah date ke bentuk string dengan format yang bisa di tentukan
  String dateReal(DateTime date) {
    final DateFormat formater = DateFormat('dd MMMM y');
    return formater.format(date);
  }


  /// mengubah date ke bentuk string
  String toDateString(DateTime date){
    final DateFormat formater = DateFormat('yyyy-MM-dd');
    return formater.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5, bottom: 3),
                child: Icon(
                  FontAwesomeIcons.shoppingBag,
                  color: Color(0xFFfa7f72),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    dateReal(date),
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.arrowRight,
                    size: 14,
                  ),
                  onPressed: () => routeTo(this.toDateString(date)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
