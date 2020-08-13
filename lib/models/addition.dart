import 'package:burgernook/models/prices.dart';
import 'package:burgernook/models/product.dart';

class Addition {
  String addition_id;
  Product addition_data;
  String price;
  bool isActive;

  Addition({
    this.addition_id,
    this.addition_data,
    this.price,
    this.isActive = false,
  });

  factory Addition.fromJson(json) {
    return Addition(
      addition_id: json['addition_id'],
      //price: Prices.fromJson(json['price']),
      price: json['price'].toString().isEmpty?"0": json['price'].toString(),
      addition_data: Product.fromJson(json['addition_data']),
    );
  }
}

List<Addition> getAdditions(Map<String, dynamic> json) {
  List<Addition> additions = List();
  List data = json['additions'];
  if (data != null && data.isNotEmpty) {
    print(data);
    for (var item in data) {
      additions.add(Addition.fromJson(item));
    }
  }
  return additions;
}
