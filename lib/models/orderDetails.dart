import 'package:burgernook/models/prices.dart';

import 'addition.dart';

class OrderDetails {
  Prices prices;
  int count;
  String note;
  String drink;
  String total;

  List<Addition> orderAdditions;

  OrderDetails({
    this.prices,
    this.count = 1,
    this.note = '',
    this.drink = 'Pepsi',
    this.orderAdditions ,
    this.total = '',
  });
}
