import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/category.dart';
import 'package:burgernook/models/product.dart';
import 'package:burgernook/screens/owner/category/addProduct.dart';
import 'package:burgernook/screens/owner/category/EditProduct.dart';

class AllProductsScreen extends StatefulWidget {
  Category category;

  AllProductsScreen({this.category});

  @override
  _AllProductsScreenScreeState createState() => _AllProductsScreenScreeState();
}

class _AllProductsScreenScreeState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("العناصر ${widget.category.nameAr}"),
      ),
      body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: widget.category.products.map((Product product) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProduct(
                              product: product,
                            ))).then((value) => () {
                      if (value != null) {
                        product = value;
                        setState(() {});
                      }
                    });
              },
              child: Card(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              '$domain/image/uploads/${product.imageName}',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _delete(context, product, () async {
                                  Navigator.pop(context);
                                  progress(context: context, isLoading: true);
                                  bool result = await product.delete();
                                  progress(context: context, isLoading: false);
                                  if (result) {
                                    widget.category.products.remove(product);
                                    setState(() {});
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: 150,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(child: Text('${product.nameAr}')),
                            //Container(alignment:Alignment.center,width: 100,height: 20,child: Text('${product.nameEn}')),
                            //   Container(alignment:Alignment.center,width: 100,height: 20,child: Text('${product.nameAr}'),),
                            Flexible(
                              child: Text('السعر : ${product.prices[0].price}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ), /*Card(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.network(
                        '$domain/image/uploads/${product.imageName}',
                        width: 100,
                        height: 100,
                      ),
                      Text(''),
                      Container(alignment:Alignment.center,width: 100,height: 20,child: Text('${product.nameEn}')),
                      Container(alignment:Alignment.center,width: 100,height: 20,child: Text('${product.nameAr}'),),
                      Flexible(child: Text('السعر : ${product.price}')),
                    ],
                  ),
                ),
              ),*/
            );
          }).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddProduct(
                        category: widget.category,
                      ))).then((value) {
            if (value != null) {
              setState(() {
                widget.category.products.add(value);
              });
            }
          });
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<void> _delete(context, Product product, Function fun) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("حذف  ${product.nameAr}"),
        content: Text("هل تريد الحذف"),
        actions: <Widget>[
          FlatButton(
            child: Text("لا"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("نعم"),
            onPressed: fun,
          )
        ],
      );
    },
  );
}
