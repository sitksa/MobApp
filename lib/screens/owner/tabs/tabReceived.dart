import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/widgets/orderItem.dart';

bool loadingReceived = true;

class TabReceived extends StatefulWidget {
  List<Order> order;

  TabReceived({this.order});

  @override
  _TabReceivedState createState() => _TabReceivedState();
}

class _TabReceivedState extends State<TabReceived> {
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
        : !loadingReceived && widget.order.isEmpty
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
