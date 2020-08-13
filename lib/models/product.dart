import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:path/path.dart';

import 'addition.dart';
import 'prices.dart';

class Product {
  String id;
  String categoryId;
  String nameAr;
  String nameEn;
  String prduct_components;
  String prduct_componentsEn;
  String imageName;
  File imageFile;
  String count;
  String has_drink;
  String drink;
  String size;
  String note;
  List<Prices> prices;
  Prices price;
  List<Addition> additions;
  List<Addition> orderAdditions;

  Product({
    this.id = '',
    this.categoryId = '',
    this.nameAr = '',
    this.nameEn = '',
    this.prduct_components = '',
    this.prduct_componentsEn = '',
    this.imageName = '',
    this.imageFile,
    this.count = "",
    this.has_drink,
    this.drink = "Pepsi",
    this.prices,
    this.price,
    this.additions,
    this.note="",
    this.size="",
    this.orderAdditions,
  });

  toMap() {
    return {
      "id": this.id,
      "categoryId": this.categoryId,
      "nameAr": this.nameAr,
      "prduct_components": this.prduct_components,
      "imageName": this.imageName,
      "count": this.count,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      nameAr: json['title_ar'].toString().replaceAll("&amp;", "&"),
      nameEn: json['title_en'].toString().replaceAll("&amp;", "&"),
      prduct_components: json['prduct_components'].toString().replaceAll("&amp;", "&"),
      prduct_componentsEn: json['prduct_components_en'].toString().replaceAll("&amp;", "&"),
      imageName: json['image_name'],
      categoryId: json['category_id'],
      has_drink: json['has_drink'],
      prices: getPrices(json),
      additions: getAdditions(json),
    );
  }
  factory Product.fromJson2(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      nameAr: json['title_ar'].toString().replaceAll("&amp;", "&"),
      nameEn: json['title_en'].toString().replaceAll("&amp;", "&"),
      prduct_components: json['prduct_components'].toString().replaceAll("&amp;", "&"),
      prduct_componentsEn: json['prduct_components_en'].toString().replaceAll("&amp;", "&"),
      imageName: json['image_name'],
      categoryId: json['category_id'],
      has_drink: json['has_drink'],
      size: json['size'],
      drink: json['drink'],
      count: json['count'],
      price: Prices(price: json['price']),
      note: json['note'],
      prices: getPrices(json),
      additions: getAdditions(json),
    );
  }

  List<Product> getProducts(Map<String, dynamic> json) {
    List<Product> products = List();
    List data = json['products'];
    for (var item in data) {
      Product product = Product.fromJson(item);
      product.price = Prices.fromJson(item['prices'][0]);
      products.add(product);
    }
    return products;
  }

  Future<bool> update() async {
    print(this.id);
    http.Response response =
        await http.post("$domain/product/update.php", body: {
      "product_id": this.id,
      "title_ar": this.nameAr,
      "prduct_desc": this.prduct_components,
    });
    var res = json.decode(response.body);
    print(res);
    if (!res['error']) {
      return true;
    }
    return false;
  }

  Future<bool> delete() async {
    print(this.id);
    http.Response response =
        await http.post("$domain/product/delete.php", body: {
      "product_id": this.id,
    });
    var res = json.decode(response.body);
    print(res);
    if (!res['error']) {
      return true;
    }
    return false;
  }

  Future<bool> setProduct() async {
    print(this.nameAr);
    print(this.categoryId);
    print(this.imageFile.path);
    var stream =
        new http.ByteStream(DelegatingStream.typed(this.imageFile.openRead()));
    var length = await this.imageFile.length();
    var uri = Uri.parse("$domain/product/create.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(this.imageFile.path));
    request.fields['title_ar'] = this.nameAr;
    request.fields['prduct_desc'] = this.prduct_components;
    request.fields['category_id'] = this.categoryId;
    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      this.imageName = basename(this.imageFile.path);
      print("Image Uploaded");
      return true;
    } else {
      print("Upload Failed");
      return false;
    }
  }

  Future<List<Product>> getProductsByCategoryId(String categoryId) async {
    List<Product> products = List();
    http.Response response = await http.post(
        "$domain/product/readByCategoryId.php",
        body: {"category_id": categoryId});
    var res = json.decode(response.body);
    print(res);
    List data = res['product'];
    for (var item in data) {
      products.add(Product.fromJson(item));
    }
    return products;
  }
}

Future<List<Product>> getProductOFOrder(String orderId) async {
  List<Product> products = List();
  http.Response response =
      await http.post("$domain/ordersDetails/readByOrderId.php", body: {
    "order_id": orderId,
  });
  var res = json.decode(response.body);
  print(res);
  List data = res['products'];
  for (var item in data) {
    Product product = Product.fromJson2(item);
    List orderAdditions = item['OrderAdditions'];
    product.orderAdditions = List();
    for(var item2 in orderAdditions){
      print(item2['addition_data']['title_ar']);

      Addition addition = Addition();
      addition.addition_id = item2['addition_id'];
      addition.price = item2['orders_additions_price'];
      addition.addition_data = Product.fromJson(item2['addition_data']);
      product.orderAdditions.add(addition);
    }
    products.add(product);
  }
  return products;
}
