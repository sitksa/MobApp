import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/addition.dart';
import 'package:burgernook/models/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/screens/image/showImage.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  Product product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int counter = 0;
  int value = 0;
  Product product;
  bool errorNote = false;
  String errorN = '';
  OrderDetails orderDetails = OrderDetails();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.product.price = widget.product.prices[0];
    orderDetails.orderAdditions = List();
    orderDetails.total = widget.product.prices[0].price;
    for (Addition item in widget.product.additions) {
      item.isActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Basket>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          appLocalizations.translate("details"), //  'تفاصيل',
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowImage(
                            url:
                                '$domain/image/uploads/${widget.product.imageName}',
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                '$domain/image/uploads/${widget.product.imageName}',
                height: MediaQuery.of(context).size.width - 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width - 150,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: 25, bottom: 5, left: 15, right: 15),
                    child: Text(
                      "${AppLocalizations.of(context).locale.languageCode != "en" || widget.product.nameEn.isEmpty ? widget.product.nameAr : widget.product.nameEn}",
                      style: TextStyle(color: mainColor, fontSize: 25),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  color: accentW,
                  alignment: Alignment.center,
                  child: Text(
                    '${appLocalizations.translate("Total")} ${orderDetails.total} SR',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: colorG, fontSize: 25, fontFamily: "arlrdbd"),
                  ),
                ),
                widget.product.prices[0].size_id == "16"
                    ? Container()
                    : Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        color: accentW,
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            widget.product.prices.isEmpty
                                ? Container()
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      appLocalizations
                                          .translate("Choose the size"),
                                      //     'اختر الحجم',
                                      style: TextStyle(
                                        color: accentColor5,
                                      ),
                                    ),
                                  ),
                            Container(
                              height:
                                  56 * widget.product.prices.length.toDouble(),
                              child: ListView.builder(
                                itemCount: widget.product.prices.length,
                                itemBuilder: (context, index) {
                                  return RadioListTile(
                                    value: index,
                                    groupValue: value,
                                    onChanged: (index) => setState(() {
                                      /*  value = index;
                                      orderDetails.total =
                                          widget.product.prices[index].price;
                                     */
                                      double price =
                                          (double.parse(orderDetails.total) -
                                              double.parse(widget.product
                                                  .prices[value].price));
                                      price = price +
                                          double.parse(widget
                                              .product.prices[index].price);
                                      orderDetails.total = price
                                          .toString(); //(double.parse(orderDetails.total) + price).toString();
                                      value = index;
                                      widget.product.price =
                                          widget.product.prices[index];
                                    }),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            "${appLocalizations.locale.languageCode == "en" ? widget.product.prices[index].size_name == "وسط" ? "Middle" : "Large" : widget.product.prices[index].size_name}"),
                                        Text(
                                          "${widget.product.prices[index].price} SR",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontFamily: "arlrdbd",
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: accentW,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.4),
                                blurRadius: 12)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                appLocalizations.translate("the ingredients"),
                                //   'المكونات',
                                style: TextStyle(
                                  color: colorG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                //    '${widget.product.prduct_components}',
                                "${AppLocalizations.of(context).locale.languageCode != "en" || widget.product.prduct_componentsEn.isEmpty ? widget.product.prduct_components : widget.product.prduct_componentsEn}",

                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 30, left: 30, right: 30),
                  child: Container(
                      decoration: BoxDecoration(
                          color: accentW,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.4),
                                blurRadius: 12)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.product.additions.isNotEmpty
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      appLocalizations.translate("Additions"),
                                      //     'الاضافات',
                                      style: TextStyle(
                                        color: colorG,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.product.additions
                                    .map((Addition addition) {
                                  counter++;
                                  return CheckboxListTile(
                                    value: addition.isActive,
                                    onChanged: (value) {
                                      print(value);
                                      addition.isActive = value;
                                      if (addition.isActive) {
                                        double price = double.parse(
                                                addition.price) +
                                            double.parse(orderDetails.total);
                                        orderDetails.total = price.toString();
                                        orderDetails.orderAdditions
                                            .add(addition);
                                      } else {
                                        double price =
                                            double.parse(orderDetails.total) -
                                                double.parse(addition.price);
                                        orderDetails.total = price.toString();
                                        orderDetails.orderAdditions
                                            .remove(addition);
                                      }
                                      setState(() {});
                                    },
                                    secondary: Text(
                                      ' ${AppLocalizations.of(context).locale.languageCode != "en" || addition.addition_data.nameEn.isEmpty ? addition.addition_data.nameAr : addition.addition_data.nameEn}',
                                      style: TextStyle(color: accentColor5),
                                    ),
                                    title: Text(
                                      "${addition.price} SR",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontFamily: "arlrdbd",
                                        color: accentColor,
                                      ),
                                    ),
                                  );
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
                                      style: TextStyle(color: accentColor5),
                                    ),
                                    trailing: Text(
                                      "${addition.price} SR",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontFamily: "arlrdbd",
                                        color: colorG,
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ],
                        ),
                      )),
                ),
                widget.product.has_drink == "Yes"
                    ? Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 14),
                              //  padding: EdgeInsets.all(8.0),
                              child: Text(
                                appLocalizations.translate(
                                    "Choose a drink type"), // 'اختر نوع المشروب',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 14),
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: orderDetails.drink,
                                items: <String>[
                                  "Pepsi",
                                  "7-UP",
                                  //     "water",
                                  "Miranda",
                                  "mountain dew",
                                  "Diet Pepsi",
                                  //    "ice Tea",
                                  //    "cocktail juice",
                                  //    "Apple juice",
                                  //    "Orange juice",
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  //   widget.product.drink = value;
                                  orderDetails.drink = value;
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextField(
                    maxLines: 20,
                    maxLength: 900,
                    minLines: 4,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorText: errorNote ? errorN : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(Icons.details),
                      labelText: appLocalizations.translate(
                          "Add more details"), //'اضف المذيد من التفاصيل',
                    ),
                    onChanged: (input) {
                      //   widget.product.price.note = input;
                      orderDetails.note = input;
                    },
                    onSubmitted: (input) {},
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    widget.product.price.product = widget.product;
                    orderDetails.prices = widget.product.price;
                    basket.setOrderDetails(orderDetails);
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 50),
                      width: 130,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          appLocalizations.translate("addition"), // 'إضافة',
                          style: TextStyle(fontSize: 24),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
