import 'dart:convert';

import 'package:burgernook/models/addition.dart';
import 'package:burgernook/models/orderDetails.dart';
import 'package:burgernook/models/prices.dart';
import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/models/user/address.dart';
import 'package:burgernook/models/user/user.dart';

class Order {
  String id;
  String userId;
  String addressId;
  String p_total;
  String p_tax;
  String tax;
  String p_total_w_tax;
  String p_delivery;
  String p_invoice;

  List<OrderDetails> orderDetailsList;
  String createdAt;
  String date;
  String time;
  String error;
  String assignedId;
  User assignedUser;
  User user = User();
  Address address;
  String orderType;
  String paymentType;

  /// [status] == 0 >>>> new
  /// [status] == 1 >>>> notDelivered
  /// [status] == 2 >>>> received
  String status;

  Order({
    this.id = '',
    this.userId = '',
    this.addressId = '',
    this.p_total = '',
    this.p_tax = '',
    this.tax = '',
    this.p_total_w_tax = '',
    this.p_delivery = '',
    this.p_invoice = '',
    this.status,
    this.createdAt = '',
    this.error = '',
    this.date = '',
    this.time = '',
    this.user,
    this.assignedId = '',
    this.address,
    this.assignedUser,
    this.orderType = "توصيل",
    this.paymentType = "كاش",
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'],
      userId: json['user_id'],
      addressId: json['address_id'],
      p_total: json['p_total'],
      p_tax: json['p_tax'],
      tax: json['tax'],
      p_total_w_tax: json['p_total_w_tax'],
      p_delivery: json['p_delivery'],
      p_invoice: json['p_invoice'],
      status: json['status'],
      createdAt: json['created_at'],
      date: json['date'],
      time: json['time'],
      assignedId: json['assigned_id'],
      assignedUser: User.fromJson(json['assigned_user']),
      user: User.fromJson(json),
      address: Address.fromJson(json['address']),
      orderType: json['order_type'],
      paymentType: json['payment_type'],
    );
  }

  toMap() {
    Map<String, dynamic> map = {
      'user_id': globalUser.id,
      'address_id': this.addressId,
      'p_total': this.p_total,
      'p_tax': this.p_tax,
      'tax': this.tax,
      'p_total_w_tax': this.p_total_w_tax,
      'p_delivery': this.p_delivery,
      'p_invoice': this.p_invoice,
      'order_type': this.orderType,
      'payment_type': this.paymentType,
    };

    return map;
  }

  Future<bool> setOrder() async {
    http.Response response =
        await http.post("$domain/order/create.php", body: this.toMap());
    var res = json.decode(response.body);
    print(response.body);
    //print(res);
    if (!res['error']) {
      for (OrderDetails p in this.orderDetailsList) {
        setOrderDetails(p, res['last_order_id'].toString());
      }
      return true;
    } else {
      this.error = res['message'];
      return false;
    }
  }

  Future<bool> setOrderDetails(
      OrderDetails orderDetails, String orderId) async {
    Prices prices = orderDetails.prices;
    http.Response response =
        await http.post("$domain/ordersDetails/create.php", body: {
      "order_id": orderId,
      "product_id": prices.product.id,
      "product_price": prices.price,
      "quantity": orderDetails.count.toString(),
      "size": prices.size_name,
      "drink": prices.product.has_drink == "Yes" || orderDetails.drink == null
          ? orderDetails.drink
          : "",
      "note": orderDetails.note == null ? "" : orderDetails.note,
    });
    var res = json.decode(response.body);
    print(response.body);
    //print(res);
    if (!res['error']) {
      for (Addition p in orderDetails.orderAdditions) {
        setOrderAdditions(p, orderDetails, res['order_details_id'].toString());
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setOrderAdditions(Addition orderAdditions,
      OrderDetails orderDetails, String order_details_id) async {
    print(orderAdditions.addition_data.id);
    print(orderAdditions.addition_data.nameAr);
    http.Response response =
        await http.post("$domain/ordersAdditions/create.php", body: {
      "order_details_id": order_details_id.toString(),
      "product_id": orderDetails.prices.product_id.toString(),
      "addition_id": orderAdditions.addition_data.id.toString(),
      "orders_additions_price": orderAdditions.price.toString(),
    });
    var res = json.decode(response.body);
    print(response.body);
    //print(res);
    if (!res['error']) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrderStatus({String statusID}) async {
    http.Response response =
        await http.post("$domain/order/updateOrderStatus.php", body: {
      "status_id": statusID,
      "order_id": this.id,
    });
    var res = json.decode(response.body);
    // print(res);
    if (!res['error']) {
      return true;
    } else {
      this.error = res['message'];
      return false;
    }
  }

  Future<bool> assignedOrderToDelivery({User user}) async {
    http.Response response =
        await http.post("$domain/order/assignedOrderToDelivery.php", body: {
      "assigned_id": user.id,
      "order_id": this.id,
    });
    var res = json.decode(response.body);
    //  print(res);
    if (!res['error']) {
      return true;
    } else {
      this.error = res['message'];
      return false;
    }
  }

  Future<List<Order>> getOrdersOfUser() async {
    List<Order> orders = List();
    if (globalUser.id != '0') {
      http.Response response =
          await http.post("$domain/order/readByUserId.php", body: {
        "user_id": globalUser.id,
      });
      //print(response.body);

      var res = json.decode(response.body);
      List data = res['order'];
      // print(res);
      for (var item in data) {
        orders.insert(0, Order.fromJson(item));
      }
    }
    return orders;
  }

  Future<List<Order>> getOrdersByStatusId({String statusId}) async {
    List<Order> orders = List();
    http.Response response = await http.post("$domain/order/read.php", body: {
      "order": "order",
    });
    var res = json.decode(response.body);
    List data = res['order'];
    // print(res);
    for (var item in data) {
      if (item['status'] == statusId) {
        orders.insert(0, Order.fromJson(item));
      }
    }
    return orders;
  }

  Future<List<Order>> getAllOrdersByUserID() async {
    List<Order> orders = List();
    http.Response response = await http.post(
        "$domain/order/readByAssignedId.php",
        body: {"assigned_id": globalUser.id});
    print(response.body);
    var res = json.decode(response.body);
    //print(res);
    List data = res['order'];
    for (var item in data) {
      orders.add(Order.fromJson(item));
    }
    return orders;
  }

  Future<List<Order>> getAllOrder() async {
    List<Order> orders = List();
    http.Response response =
        await http.post("$domain/order/read.php", body: {"order": "order"});
    var res = json.decode(response.body);
    // print(res);
    List data = res['order'];
    for (var item in data) {
      orders.add(Order.fromJson(item));
    }
    return orders;
  }
}
