import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/widgets/orderItem.dart';
import 'detailsOrder.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(AppLocalizations.of(context).translate("Requests")),
      ),
      body: FutureBuilder<List<Order>>(
        future: Order().getOrdersOfUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.isNotEmpty) {
              return ListView(
                children: snapshot.data.map((Order order) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsOrder(
                                    order: order,
                                  ))).then((value) {
                        if (value == true) {
                          setState(() {});
                        }
                      });
                    },
                    child: OrderItem(
                      order: order,
                    ),
                  );
                }).toList(),
              );
            } else {
              return emptyWidget();
            }
          }
          return myCircularProgressIndicator();
        },
      ),
    );
  }
}
