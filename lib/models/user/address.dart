import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';

class Address {
  String id;
  String userId;
  String addressTitle;
  String address;
  String addressInMap;
  String latitude;
  String longitude;
  String error;

  Address({
    this.id = '',
    this.userId = '',
    this.addressTitle = '',
    this.address = '',
    this.addressInMap = '',
    this.latitude = '',
    this.longitude = '',
    this.error = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id'],
      userId: json['user_id'],
      addressTitle: json['address_title'],
      address: json['address'],
      addressInMap: json['address_in_map'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  toMap() {
    return {
      "user_id": globalUser.id,
      "address_title": this.addressTitle,
      "address": this.address,
      "address_in_map": this.addressInMap,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }

  Future<bool> setAddress() async {
    http.Response response =
        await http.post("$domain/address/create.php", body: this.toMap());
    var res = json.decode(response.body);
    print(res);
    if (!res['error']) {
      this.id = res['id'];
      return true;
    } else {
      this.error = res['message'];
      return false;
    }
  }

  Future<List<Address>> getAddress() async {
    List<Address> address = List();
    if (globalUser.id != '0') {
      print(globalUser.id);
      http.Response response = await http.post(
          "$domain/address/readByUserId.php",
          body: {"user_id": globalUser.id});
      var res = json.decode(response.body);
      print(res);
      List data = res['address'];
      for (var item in data) {
        address.add(Address.fromJson(item));
      }
    }
    return address;
  }
}
