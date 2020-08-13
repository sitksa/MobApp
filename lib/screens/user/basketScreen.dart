import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/addition.dart';
import 'package:burgernook/models/orderDetails.dart';
import 'package:burgernook/models/user/address.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/screens/loginData/loginScreen.dart';
import 'package:burgernook/screens/user/ordersScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'addAddressScreen.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String chooseAddress = "";
  var delivery = "0.0";
  var tax = "0.0";
  var total = "0.0";
  double priceTax = 0.0;

  // double totalWithTax = 0.0;
  double _total = 0.00;
  Order order = Order();
  List<Address> address = List();
  bool isLoading = true;
  int value = 1000000;

  _getAddress() async {
    if (connected) {
      setState(() {
        isLoading = true;
      });
      address = await Address().getAddress();
      setState(() {
        isLoading = false;
      });
    }
  }

  getDataFromLockups() async {
    http.Response response =
        await http.post("$domain/lockups/read.php", body: {"data": "data"});
    var data = json.decode(response.body);
    List lockups = data['lockups'];
    for (var item in lockups) {
      if (item['code_name'] == "delivery_p") {
        delivery = item['name'];
      }
      if (item['code_name'] == "tax") {
        tax = item['name'];
      }
    }
    // total = (_total + double.parse(delivery)+ double.parse(tax)).toString();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromLockups();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Basket>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    if (basket.getOrderDetails().isNotEmpty) {
      _total = basket.getTotal();
      if (basket.getIsDelivery()) {
        priceTax = double.parse(
            (((double.parse(tax) / 100) * (_total + double.parse(delivery))))
                .toStringAsFixed(2));
      } else {
        priceTax = double.parse(
            (((double.parse(tax) / 100) * _total)).toStringAsFixed(2));
      }

      //totalWithTax = double.parse((double.parse(delivery) + _total + priceTax).toStringAsFixed(2));
      if (basket.getIsDelivery()) {
        total = (_total + double.parse(delivery) + priceTax).toStringAsFixed(2);
      } else {
        total = (_total + priceTax).toStringAsFixed(2);
      }
    } else {
      delivery = '0.0';
      tax = '0.0';
      total = '0.0';
      priceTax = 0.0;
      //   totalWithTax = 0.0;
      _total = 0.0;
      //  basket.clear();
    }
    setState(() {});

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          appLocalizations.translate("The basket"),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: basket.getOrderDetails().isNotEmpty
                    ? Column(
                        children: basket
                            .getOrderDetails()
                            .map((OrderDetails orderDetails) {
                          Product product = orderDetails.prices.product;
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                    /*  onTap:(){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetails(product: product)));
                                  },*/
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
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  '${product.nameAr}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: accentColor5),
                                                ),
                                                orderDetails.prices.size_id ==
                                                        "16"
                                                    ? Container()
                                                    : Text(
                                                        "${appLocalizations.locale.languageCode == "en" ? orderDetails.prices.size_name == "وسط" ? "Middle" : "Large" : orderDetails.prices.size_name}",
                                                        //'${orderDetails.prices.size_name}',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: colorG),
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
                                                    fontFamily: "",
                                                    color: accentColor5,
                                                  )),
                                              Text(' x',
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  style: TextStyle(
                                                    color: accentColor,
                                                  )),
                                              Text(
                                                '${orderDetails.prices.price} SR',
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
                                    subtitle: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            basket
                                                .setOrderDetails(orderDetails);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                color: accentColor5,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 25,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          padding: EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            // shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${orderDetails.count}',
                                            style: TextStyle(
                                              fontFamily: "arlrdbd",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: orderDetails.count == 1
                                              ? null
                                              : () {
                                                  basket.incrementOrderDetails(
                                                      orderDetails);
                                                },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: accentColor5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        basket.deleteOrderDetails(orderDetails);
                                      },
                                      child: Image.asset(
                                        "assets/close.png",
                                        height: 15,
                                      ),
                                    )),
                                orderDetails.note == null ||
                                        orderDetails.note.isEmpty
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                            "${appLocalizations.translate("Notes")} : ${orderDetails.note}"),
                                      ),
                                orderDetails.prices.product.has_drink == null ||
                                        orderDetails.prices.product.has_drink !=
                                            "Yes"
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                            "${appLocalizations.translate("drink type")} : ${orderDetails.drink}"),
                                      ),
                                orderDetails.orderAdditions == null ||
                                        orderDetails.orderAdditions.isEmpty
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                  "${appLocalizations.translate("Additions")}"),
                                            ),
                                            Column(
                                              children: orderDetails
                                                  .orderAdditions
                                                  .map((Addition addition) {
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
                                                    ' ${AppLocalizations.of(context).locale.languageCode != "en" || addition.addition_data.nameEn.isEmpty ? addition.addition_data.nameAr : addition.addition_data.nameEn}"}',
                                                    style: TextStyle(
                                                        color: accentColor5),
                                                  ),
                                                  trailing: Text(
                                                    "${addition.price} SR",
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: TextStyle(
                                                      fontFamily: "arlrdbd",
                                                      color: colorG,
                                                    ),
                                                  ),
                                                );
                                                return Container(
                                                  width: MediaQuery.of(context)
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
                                orderDetails.total == null ||
                                        orderDetails.total.isEmpty
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          "${appLocalizations.translate("Total")} : ${orderDetails.total}",
                                          style: TextStyle(
                                              fontFamily: "",
                                              color: accentColor),
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
                                /*    Positioned(
                                  bottom: 30,
                                  right: 0,
                                  left: 50,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: Text(
                                      'فارغ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      )),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            //  padding: EdgeInsets.all(8.0),
            child: Text(
              appLocalizations.translate('Choose the order type'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: basket.getOrderType(),
              items: appLocalizations.locale.languageCode == "en"
                  ? <String>['', 'Delivery', 'My travel', 'Sweetened']
                      .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList()
                  : <String>['', 'توصيل', 'سفري', 'محلي'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
              onChanged: (value) {
                if (value == "توصيل" || value == "Delivery") {
                  basket.setIsDelivery(true);
                } else {
                  basket.setIsDelivery(false);
                }
                basket.setOrderType(value);
                //order.orderType = value;
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            //  padding: EdgeInsets.all(8.0),
            child: Text(
              appLocalizations.translate('Choose your payment type'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: basket.getPaymentType(),
              items: appLocalizations.locale.languageCode == "en"
                  ? <String>[
                      '',
                      'Cash',
                      'Network',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList()
                  : <String>[
                      '',
                      'كاش',
                      'شبكة',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
              onChanged: (value) {
                basket.setPaymentType(value);
                //order.orderType = value;
                setState(() {});
              },
            ),
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
                        Text(appLocalizations.translate('Total')),
                        Text(
                          '$_total SR',
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
                    basket.getIsDelivery()
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                appLocalizations.translate('Delivery'),
                              ),
                              Text(
                                '${delivery} SR',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontFamily: "arlrdbd",
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    basket.getIsDelivery()
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
                          '${appLocalizations.translate('VAT')} $tax %',
                          style: TextStyle(
                            fontFamily: "",
                          ),
                        ),
                        Text(
                          '$priceTax',
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
                    /* basket.getIsDelivery()
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('الاجمالي بالضريبة'),
                              Text(
                                '${totalWithTax} SR',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontFamily: "arlrdbd",
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    basket.getIsDelivery()
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
                        Text(
                          appLocalizations.translate('Total bill'),
                        ),
                        Text(
                          '$total SR',
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: accentW,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: isLoading
                  ? myCircularProgressIndicator()
                  : Column(
                      children: <Widget>[
                        chooseAddress.isEmpty
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  chooseAddress,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                        address.isEmpty
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8.0),

                                ///margin: EdgeInsets.only(right: 20, top: 0),
                                child: Text(
                                  appLocalizations
                                      .translate('Choose address *'),
                                  style: TextStyle(
                                    color: accentColor5,
                                  ),
                                ),
                              ),
                        Container(
                          height: 56 * address.length.toDouble(),
                          child: ListView.builder(
                            itemCount: address.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                value: index,
                                groupValue: value,
                                onChanged: (ind) => setState(() {
                                  value = ind;
                                  basket.setAddress(address[index]);
                                }),
                                title: Text("${address[index].addressTitle}"),
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isLogin) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddAddressScreen())).then((_address) {
                                if (_address != null) {
                                  setState(() {
                                    address.add(_address);
                                  });
                                }
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  appLocalizations.translate('Add an address'),
                                  style: TextStyle(
                                      color: accentColor5, fontSize: 16),
                                ),
                                Icon(
                                  Icons.add_circle,
                                  color: accentColor5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: basket.getOrderDetails().isEmpty ||
                    basket.getAddress().id.isEmpty
                ? () {
                    if (this.mounted) {
                      setState(() {
                        chooseAddress = appLocalizations
                            .translate("Please choose an address");
                      });
                    }
                    print("dfsf");
                  }
                : () async {
                    if (this.mounted) {
                      setState(() {
                        chooseAddress = '';
                      });
                    }
                    if (isLogin) {
                      if (isUser) {
                        if (connected) {
                          //      print('>>>>>>>>>>>>>>>>>>>>>>>>>isUser');
                          order.addressId = basket.getAddress().id;
                          print(basket.getAddress().id);
                          order.orderDetailsList = basket.getOrderDetails();
                          order.p_total = _total.toString();
                          order.p_tax = priceTax.toString();
                          order.tax = tax.toString();
                          order.p_total_w_tax =
                              total; //totalWithTax.toString();
                          order.p_delivery = "";
                          if (basket.getIsDelivery()) {
                            order.p_delivery = delivery;
                          }

                          order.orderType = basket.getOrderType();
                          order.paymentType = basket.getPaymentType();
                          order.p_invoice = total;
                          if (order.orderDetailsList.isNotEmpty &&
                              order.addressId.isNotEmpty &&
                              order.orderType.isNotEmpty &&
                              order.paymentType.isNotEmpty &&
                              connected) {
                            progress(context: context, isLoading: true);
                            //print(">>>>>>>>>user.id ${globalUser.id}");
                            bool result = await order.setOrder();
                            progress(context: context, isLoading: false);
                            if (result) {
                              basket.clear();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersScreen()));
                            } else {
                              switch (order.error) {
                                case "address_id":
                                  break;
                              }
                            }
                          } else {
                            if (!connected) {
                              notConnected(context: context);
                            }

                            if (order.orderDetailsList.isEmpty) {
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text("Please choose the order"),
                              ));
                            } else if (order.orderType.isEmpty) {
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text("Please choose the order type"),
                              ));
                            } else if (order.paymentType.isEmpty) {
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text("Please choose a payment method"),
                              ));
                            }
                          }
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                    }
                  },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                appLocalizations.translate('Request'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
