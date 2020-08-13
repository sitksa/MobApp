import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/category.dart';
import 'package:burgernook/screens/owner/category/addCategory.dart';
import 'package:burgernook/screens/owner/category/productsScreen.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _EmployeeScreenScreeState createState() => _EmployeeScreenScreeState();
}

class _EmployeeScreenScreeState extends State<AllCategoriesScreen> {
  bool loading = true;
  List<Category> categories = List();

  _getUsers() async {
    if (connected) {
      setState(() {
        loading = true;
      });
      categories = await Category().fetchCategoryData();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("الفئات"),
      ),
      body: loading
          ? myCircularProgressIndicator()
          : ListView(
              children: categories.map((Category category) {
              return Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductsScreen(
                                category: category,
                              )));
                },
                leading: Container(
                    margin: EdgeInsets.all(5),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 35,
                    )),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  //  Text("الاسم بالانجليزي : ${category.nameEn}"),
                    Text("${category.nameAr}"),
                    Text("${category.products.length} عنصر"),
                  ],
                ),
              ));
            }).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCategory()))
              .then((value) {
            if (value != null) {
              setState(() {
                categories.add(value);
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
