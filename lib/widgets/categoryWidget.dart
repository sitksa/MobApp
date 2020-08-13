import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/category.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/screens/user/productDetails.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  Category category;

  CategoryWidget({this.category});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: accentW,
                  boxShadow: [
                    BoxShadow(
                        color: accentColor5.withOpacity(.3),
                        blurRadius: 8,
                        offset: Offset.fromDirection(140))
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                appLocalizations.locale.languageCode=="en"?widget.category.nameEn:widget.category.nameAr,
                style: TextStyle(
                    fontFamily: "GE_Dinar_One_Medium",
                    color: accentColor5,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.only(right: 5, left: 5),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.category.products.map((Product product) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(product: product)));
                  },
                  child: MyCard(product),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  Product product;

  MyCard(this.product);

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Basket>(context);
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Container(
        //padding: EdgeInsets.all(2),
        //  margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: accentColor5.withOpacity(.3),
                blurRadius: 6,
                offset: Offset.fromDirection(140)),
          ],
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
              '$domain/image/uploads/${product.imageName}',
            ),
            fit: BoxFit.contain,
          ),
        ),
        width: 135,
        height: 200,
        child: Container(
          width: 135,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    "${AppLocalizations.of(context).locale.languageCode!="en" ||product.nameEn.isEmpty? product.nameAr:product.nameEn}",
                    style: TextStyle(
                      fontSize: 18,
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  InkWell(
                      onTap: () {
                        product.price.product = product;
                        OrderDetails orderDetails =
                            OrderDetails(prices: product.price ,total: product.price.price,orderAdditions: []);
                        basket.setOrderDetails(orderDetails);
                      },
                      child: Image.asset("assets/add.png", width: 25)),
                ],
              ),
              Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.only(top: 12, left: 4),
                decoration: BoxDecoration(
                  color: colorG,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${product.price.price} SR",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: "arlrdbd",
                    color: accentW,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
