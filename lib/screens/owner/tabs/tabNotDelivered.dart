import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/widgets/orderItem.dart';

bool loadingNotDelivered = true;

class TabNotDelivered extends StatefulWidget {
  List<Order> order;
  TabNotDelivered({this.order});

  @override
  _TabNotDeliveredState createState() => _TabNotDeliveredState();
}

class _TabNotDeliveredState extends State<TabNotDelivered> {
  @override
  Widget build(BuildContext context) {
    return widget.order.isNotEmpty
        ? ListView(
            children: widget.order.map((Order order) {
              return OrderItem(
                order: order,
                funDeleteFromList: () {
                  widget.order.remove(order);
                  setState(() {});
                },
              );
            }).toList(),
          )
        : !loadingNotDelivered && widget.order.isEmpty
            ? ListView(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 50),
                      child: emptyWidget()),
                ],
              )
            : myCircularProgressIndicator();
  }
}
