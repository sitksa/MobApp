import 'dart:async';

import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/prices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/address.dart';

import '../addition.dart';
import '../orderDetails.dart';

class Basket with ChangeNotifier {
  List<OrderDetails> _orderDetails = List();
  Address _address = Address();
  double _total = 0.00;
  double _widthBasket;
  Color _colorBasket;
  String _orderType = '';
  String _paymentType = '';
  bool _isDelivery = false;

  Basket();

  List<OrderDetails> getOrderDetails() => _orderDetails;

  double getTotal() => _total;

  Address getAddress() => _address;

  Color getColorBasket() => _colorBasket;

  double getWidthBasket() => _widthBasket;

  String getOrderType() => _orderType;

  String getPaymentType() => _paymentType;

  bool getIsDelivery() => _isDelivery;

  setOrderType(String orderType) {
    _orderType = orderType;
    notifyListeners();
  }

  setPaymentType(String paymentType) {
    _paymentType = paymentType;
    notifyListeners();
  }

  setIsDelivery(bool isDelivery) {
    _isDelivery = isDelivery;
    notifyListeners();
  }

  setAddress(Address address) {
    _address = address;
    notifyListeners();
  }

  setOrderDetails(OrderDetails orderDetails) {
    OrderDetails _orderDetail = contains(orderDetails);
    if (_orderDetail != null) {
      _orderDetail.count++;
    } else {
      _orderDetails.add(orderDetails);
    }
    //_orderDetails.add(orderDetails);
    _total += double.parse(orderDetails.total);
    setWidthAndColorBasket(35, accentColor);
    notifyListeners();
  }

  setWidthAndColorBasket(double width, Color color) {
    Timer(Duration(milliseconds: 60), () {
      _widthBasket = width;
      _colorBasket = color;
      notifyListeners();
    });
    Timer(Duration(milliseconds: 600), () {
      _widthBasket = width - 18;
      _colorBasket = Colors.red;
      notifyListeners();
    });
  }

  deleteOrderDetails(OrderDetails orderDetails) {
    _total -=
        (double.parse(orderDetails.total) * orderDetails.count).toDouble();
    orderDetails.count = 1;
    _orderDetails.remove(orderDetails);
    notifyListeners();
  }

  incrementOrderDetails(OrderDetails orderDetails) {
    //  OrderDetails _prices = contains(orderDetails);
    orderDetails.count--;
    _total -= double.parse(orderDetails.total);
    notifyListeners();
  }

  OrderDetails contains(OrderDetails orderDetails) {
    for (OrderDetails _orderDetails in _orderDetails) {
      if (_orderDetails.prices.price_id == orderDetails.prices.price_id &&
          _orderDetails.note == orderDetails.note &&
          _orderDetails.drink == orderDetails.drink) {
        if (orderDetails.orderAdditions == null &&
            _orderDetails.orderAdditions == null) {
          return _orderDetails;
        } else {
          for (Addition addition in orderDetails.orderAdditions) {
            for (Addition _addition in _orderDetails.orderAdditions) {
              if (addition.addition_id == _addition.addition_id) {
                return _orderDetails;
              }
            }
          }
          return null;
        }
      }
    }
    return null;
  }

  OrderDetails containsOld(OrderDetails orderDetails) {
    for (OrderDetails _orderDetails in _orderDetails) {
      if (_orderDetails.prices.price_id == orderDetails.prices.price_id &&
          _orderDetails.note == orderDetails.note &&
          _orderDetails.drink == orderDetails.drink) {
        return _orderDetails;
      }
    }
    return null;
  }

  bool clear() {
    _address = Address();
    //   _prices = List();
//    for (var i = 0; i < _orderDetails.length; i++) {
//      _orderDetails[i].count = 1;
//      _orderDetails[i].note = "";
//      _orderDetails[i].prices = Prices();
//    }
    _orderDetails.clear();
    _total = 0.00;
    notifyListeners();
    return true;
  }
}
