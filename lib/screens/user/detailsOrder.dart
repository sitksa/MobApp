import 'dart:async';

import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/addition.dart';
import 'package:burgernook/models/prices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/product.dart';

class DetailsOrder extends StatefulWidget {
  Order order;

  DetailsOrder({this.order});

  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  List<Product> products = List();
  bool isLoading = true;

  getDetails() async {
    products = await getProductOFOrder(widget.order.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(appLocalizations.translate("Order details")),
          actions: <Widget>[
            isUser && widget.order.status == "6"
                ? FlatButton.icon(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    label: Text(
                      appLocalizations.translate("Cancelling order"),
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () async {
                      progress(context: context, isLoading: true);
                      bool result =
                          await widget.order.updateOrderStatus(statusID: "12");
                      progress(context: context, isLoading: false);
                      if (result) {
                        Navigator.pop(context, true);
                      }
                    })
                : Container(),
            !isUser &&
                    widget.order.address.latitude.isNotEmpty &&
                    widget.order.address.longitude.isNotEmpty
                ? FlatButton.icon(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: Text(
                      appLocalizations.translate("the map"),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      launchMaps(
                          latitude: widget.order.address.latitude,
                          longitude: widget.order.address.longitude);
                      //launchMaps(latitude: '30.1370975', longitude: '31.0727804');
                    })
                : Container(),
            !isUser && isDelivery
                ? FlatButton.icon(
                    icon: Icon(
                      Icons.directions_bike,
                      color: Colors.green,
                    ),
                    label: Text(
                      appLocalizations.translate("Delivered"),
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      progress(context: context, isLoading: true);
                      bool result =
                          await widget.order.updateOrderStatus(statusID: "9");
                      progress(context: context, isLoading: false);
                      if (result) {
                        Navigator.pop(context, true);
                      }
                    })
                : Container(),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Container(height: 200, child: myCircularProgressIndicator())
                  : Container(
                      child: products.isNotEmpty
                          ? Column(
                              children: products.map((Product product) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: accentW,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.4),
                                            blurRadius: 12)
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  '$domain/image/uploads/${product.imageName}',
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                          width: 55,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Text(
                                                      '${product.nameAr}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: accentColor5),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: product.size ==
                                                              "حجم ثابت"
                                                          ? Text(
                                                              '${product.count}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "",
                                                                  fontSize: 20,
                                                                  color:
                                                                      colorG),
                                                            )
                                                          : Text(
                                                              '${product.count} ${appLocalizations.locale.languageCode == "en" ? product.size == "وسط" ? "Middle" : "Large" : product.size}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "",
                                                                  fontSize: 20,
                                                                  color:
                                                                      colorG),
                                                            ),
                                                    ),
                                                  ]),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text('1',
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: accentColor5,
                                                      )),
                                                  Text(' x',
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: TextStyle(
                                                        color: accentColor,
                                                      )),
                                                  Text(
                                                    '${product.price.price} SR',
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: TextStyle(
                                                        color: accentColor5,
                                                        fontFamily: "arlrdbd"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Container(
                                          height: 10,
                                        ),
                                      ),
                                      product.note == null ||
                                              product.note.isEmpty
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Text(
                                                  "${appLocalizations.translate("Notes")} : ${product.note}"),
                                            ),
                                      product.drink == null ||
                                              product.drink.isEmpty
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Text(
                                                  "${appLocalizations.translate("drink type")} : ${product.drink}"),
                                            ),
                                      product.orderAdditions == null ||
                                              product.orderAdditions.isEmpty
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                        "${appLocalizations.translate("Additions")}"),
                                                  ),
                                                  Column(
                                                    children: product
                                                        .orderAdditions
                                                        .map((Addition
                                                            addition) {
                                                      return ListTile(
                                                        /* leading: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              '$domain/image/uploads/${addition.addition_data.imageName}',
                                            ),
                                            fit: BoxFit.fill),
                                      ),
                                      width: 55,
                                    ),*/
                                                        title: Text(
                                                          ' ${AppLocalizations.of(context).locale.languageCode != "en" || addition.addition_data.nameEn.isEmpty ? addition.addition_data.nameAr : addition.addition_data.nameEn}',
                                                          style: TextStyle(
                                                              color:
                                                                  accentColor5),
                                                        ),
                                                        trailing: Text(
                                                          "${addition.price} SR",
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "arlrdbd",
                                                            color: colorG,
                                                          ),
                                                        ),
                                                      );
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Text(
                                                            "${appLocalizations.locale.languageCode == "en" || addition.addition_data.nameEn.isNotEmpty ? addition.addition_data.nameAr : addition.addition_data.nameEn}"),
                                                      );
                                                    }).toList(),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/basket3.png",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(appLocalizations.translate("Total")),
                          Text(
                            '${widget.order.p_total} SR',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: "arlrdbd",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 2,
                          color: accentColor5.withOpacity(.4),
                        ),
                      ),
                      widget.order.p_delivery.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(appLocalizations.translate("Delivery")),
                                Text(
                                  '${widget.order.p_delivery} SR',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "arlrdbd",
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      widget.order.p_delivery.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                height: 2,
                                color: accentColor5.withOpacity(.4),
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${appLocalizations.translate("VAT")} ${widget.order.tax} %',
                            style: TextStyle(
                              fontFamily: "",
                            ),
                          ),
                          Text(
                            '${widget.order.p_tax}',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: "arlrdbd",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 2,
                          color: accentColor5.withOpacity(.4),
                        ),
                      ),
                      /*    widget.order.p_delivery.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(appLocalizations.translate("VAT")),
                                Text(
                                  '${widget.order.p_total_w_tax} SR',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "arlrdbd",
                                  ),
                                ),
                              ],
                            )
                          : Container(),*/
                      /* widget.order.p_delivery.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                height: 2,
                                color: accentColor5.withOpacity(.4),
                              ),
                            )
                          : Container(),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(appLocalizations.translate("Total bill")),
                          Text(
                            '${widget.order.p_invoice} SR',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: "arlrdbd",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 2,
                          color: accentColor5.withOpacity(.4),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )
        /* Column(
        children: products.map((Product product) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowImage(
                                      url:
                                          '$domain/image/uploads/${product.imageName}',
                                    )));
                      },
                      child: Image.network(
                        '$domain/image/uploads/${product.imageName}',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${product.nameAr}'),
                        //    Text('${product.nameAr} - ${product.nameEn}'),
                        Text('السعر : ${product.price} ريال'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'العدد',
                        ),
                        Text(
                          '${product.count}',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    )),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
            ],
          );
        }).toList(),
      ),*/
        );
  }
}
