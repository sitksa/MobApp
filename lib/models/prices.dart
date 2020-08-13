import 'package:burgernook/models/product.dart';

class Prices {
  String price_id, size_id, size_name, product_id, price;
  Product product;
  String note;
  int count;

  Prices({
    this.product,
    this.price_id = '',
    this.size_id = '',
    this.size_name = '',
    this.product_id = '',
    this.count = 1,
    this.price = '',
    this.note = '',
  });

  factory Prices.fromJson(json) {
    return Prices(
      price_id: json['price_id'],
      size_id: json['size_id'],
      size_name: json['size_name'],
      product_id: json['product_id'],
      price: json['price'],
    );
  }
}

List<Prices> getPrices(Map<String, dynamic> json) {
  List<Prices> prices = List();
  List data = json['prices'];
  if (data != null) {
    for (var item in data) {
      Prices price = Prices.fromJson(item);
      if (price.size_id == "16") {
        prices.clear();
        prices.add(price);
        break;
      } else {
        prices.add(price);
      }
    }
  }
  return prices;
}
