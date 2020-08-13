import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/product.dart';

class Category {
  String id;
  String nameEn;
  String nameAr;
  List<Product> products;
  Category({
    this.id = "",
    this.nameEn = "",
    this.nameAr = "",
    this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      nameAr: json['title_ar'],
      nameEn: json['title_en'],
    );
  }

  Future<bool> setCategory() async {
    http.Response response =
        await http.post("$domain/categories/create.php", body: {
      "title_en": this.nameEn,
      "title_ar": this.nameAr,
    });
    var res = json.decode(response.body);
    print(res);
    if (!res['error']) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Category>> fetchCategoryData() async {
    List<Category> categories = List();
    http.Response response = await http.post("$domain/categories/read.php",
        body: {"categories": "categories"});
    print(response.body);
    var res = json.decode(response.body);

    List data = res['categories'];
    for (var item in data) {
      print(item);
      Category category = Category.fromJson(item);
      List<Product> products = Product().getProducts(item);
      category.products = products;
      categories.add(category);
    }
    return categories;
  }
}
