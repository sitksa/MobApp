import 'dart:async';
import 'dart:convert';

import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/models/user/user.dart';

class OrderItem extends StatefulWidget {
  Order order = Order();
  Function funDeleteFromList = () {};

  OrderItem({this.order, this.funDeleteFromList});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  bool showDelivery = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              trailing: Text(
                getStatus(),
                style: TextStyle(
                    color: widget.order.status == '6'
                        ? Colors.green
                        : widget.order.status == '7'
                            ? Colors.green
                            : widget.order.status == '8'
                                ? Colors.green
                                : widget.order.status == '9'
                                    ? Colors.green
                                    : widget.order.status == '23'
                                        ? Colors.green
                                        : Colors.red),
              ),

              title: isUser
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${appLocalizations.translate("Code")} : ${widget.order.id}',
                          style: TextStyle(fontFamily: 'arlrdbd'),
                        ),
                        Text(
                            '${appLocalizations.translate("order type")} : ${widget.order.orderType}'),
                        Text(
                            '${appLocalizations.translate("payment type")} : ${widget.order.paymentType}'),
                        Text(
                          '${appLocalizations.translate("order date")} : ${widget.order.date}',
                          style: TextStyle(fontFamily: 'arlrdbd'),
                        ),
                        widget.order.assignedUser.fullName.isNotEmpty
                            ? Text(
                                '${appLocalizations.translate("Delivery")} : ${widget.order.assignedUser.fullName}')
                            : Container(),
                        widget.order.assignedUser.phoneNumber.isNotEmpty
                            ? Text(
                                '${appLocalizations.translate("delivery phone")} : ${widget.order.assignedUser.phoneNumber}',
                                style: TextStyle(fontFamily: ''),
                              )
                            : Container(),
                        Text(
                          '${appLocalizations.translate("clock")} : ${widget.order.time}',
                          style: TextStyle(fontFamily: 'arlrdbd'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            '${appLocalizations.translate("customer name")} : ${widget.order.user.fullName}'),
                        Text(
                            '${appLocalizations.translate("email")} : ${widget.order.user.email}'),
                        Text(
                            '${appLocalizations.translate("Phone Number")} : ${widget.order.user.phoneNumber}',
                            style: TextStyle(fontFamily: ''),),
                        Text(
                            '${appLocalizations.translate("Address details")} : ${widget.order.address.addressInMap} '),
                        !isDelivery && widget.order.assignedId != "0"
                            ? Text(
                                '${appLocalizations.translate("Delivery")} : ${widget.order.assignedUser.fullName}')
                            : Container(),
                      ],
                    ),
              // title: Text('تاريخ الطلب : ${order.date}'),
              subtitle: Text(
                '${appLocalizations.translate("Total bill")} : ${widget.order.p_invoice} SR ',
                style: TextStyle(fontFamily: 'arlrdbd'),
              ),
            ),
            !isUser && !isDelivery
                ? Column(
                    children: <Widget>[
                      showDelivery ? allDeliveriesDropdown() : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton.icon(
                            color: Colors.deepOrangeAccent,
                            onPressed: widget.order.assignedId != "0" ||
                                    widget.order.status == '7' ||
                                    widget.order.status == '8'
                                ? null
                                : () {
                                    setState(() {
                                      showDelivery = !showDelivery;
                                    });
                                  },
                            textColor: Colors.white,
                            icon: Icon(Icons.directions_bike),
                            label: Text('اضافة الي دلفري'),
                          ),
                          RaisedButton.icon(
                            color: Colors.deepOrangeAccent,
                            onPressed: widget.order.assignedId != "0" &&
                                    (widget.order.status == '6' ||
                                        widget.order.status == '7')
                                ? () async {
                                    var statusID = '';
                                    switch (widget.order.status) {
                                      case '6':
                                        statusID = '7';
                                        break;
                                      case '7':
                                        statusID = '8';
                                        break;
                                    }
                                    progress(context: context, isLoading: true);
                                    bool reuslt = await widget.order
                                        .updateOrderStatus(statusID: statusID);
                                    progress(
                                        context: context, isLoading: false);
                                    if (reuslt) {
                                      widget.funDeleteFromList();
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            icon: Icon(Icons.done_all),
                            label: Text(widget.order.status == '6'
                                ? AppLocalizations.of(context)
                                    .translate("pending") //'قيد الانتظار'
                                : widget.order.status == '7'
                                    ? AppLocalizations.of(context).translate(
                                        "processing") // 'جارى التنفيذ'
                                    : widget.order.status == '8'
                                        ? AppLocalizations.of(context)
                                            .translate(
                                                "Connecting") // 'جارى التوصيل'
                                        : widget.order.status == '9'
                                            ? AppLocalizations.of(context)
                                                .translate(
                                                    "Delivered") //"تم التوصيل"
                                            : AppLocalizations.of(context)
                                                .translate("Cancellation")),
                          ),
                          RaisedButton.icon(
                            key: shareWidget,
                            color: Colors.deepOrangeAccent,
                            onPressed: () {
                              //_printPdf();
                            },
                            textColor: Colors.white,
                            icon: Icon(Icons.print),
                            label: Text('طباعة'),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  String getStatus() {
    return widget.order.status == '6'
        ? AppLocalizations.of(context).translate("pending") //'قيد الانتظار'
        : widget.order.status == '7'
            ? AppLocalizations.of(context)
                .translate("processing") // 'جارى التنفيذ'
            : widget.order.status == '8'
                ? AppLocalizations.of(context)
                    .translate("Connecting") // 'جارى التوصيل'
                : widget.order.status == '9'
                    ? AppLocalizations.of(context)
                        .translate("Delivered") //"تم التوصيل"
                    : widget.order.status == '23'
                        ? AppLocalizations.of(context).translate("Delivered")
                        : AppLocalizations.of(context)
                            .translate("Cancellation"); //'الغاء';
  }

  Widget allDeliveriesDropdown() {
    if (deliveries.isNotEmpty) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<User>(
                isExpanded: true,
                items: deliveries.map((User value) {
                  return DropdownMenuItem<User>(
                    value: value,
                    child: Text(value.fullName),
                  );
                }).toList(),
                value: delivery,
                onChanged: (value) {
                  delivery = value;
                  setState(() {});
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.done, color: Colors.blue),
            onPressed: () async {
              if (showDelivery) {
                progress(context: context, isLoading: true);
                bool reuslt =
                    await widget.order.assignedOrderToDelivery(user: delivery);
                progress(context: context, isLoading: false);
                if (reuslt) {
                  showDelivery = false;
                  widget.order.assignedUser.fullName = delivery.fullName;
                  widget.order.assignedId = delivery.id;
                  setState(() {});
                }
              }
            },
          ),
        ],
      );
    }
    return Container();
  }
}
