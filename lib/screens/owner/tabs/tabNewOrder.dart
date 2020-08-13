import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/widgets/orderItem.dart';

bool loadingNewOrder = true;

class TabNewOrder extends StatefulWidget {
  List<Order> order;

  TabNewOrder({this.order});

  @override
  _TabNotReceivedState createState() => _TabNotReceivedState();
}

class _TabNotReceivedState extends State<TabNewOrder> {
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
        : !loadingNewOrder && widget.order.isEmpty
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
