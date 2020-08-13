import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/category.dart';

class AddCategory extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<AddCategory> {
  Category category = Category();

  bool errorNameEn = false;
  bool errorNameAr = false;

  String errorNEn = '';
  String errorNAr = '';

  var height;
  var width;

  FocusNode focusNodeNEn = FocusNode();
  FocusNode focusNodeNAr = FocusNode();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافة"),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: height / 100 * 10,
                right: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                     /* TextField(
                        focusNode: focusNodeNEn,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorNameEn ? errorNEn : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            prefixIcon: Icon(Icons.person),
                            labelText: 'ادخل الاسم بالانجليزي'),
                        onChanged: (input) {
                          category.nameEn = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeNAr);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),*/
                      TextField(
                        focusNode: focusNodeNAr,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorNameAr ? errorNAr : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            prefixIcon: Icon(Icons.title),
                            labelText: 'ادخل الاسم'),
                        onChanged: (input) {
                          category.nameAr = input;
                        },
                        onSubmitted: (input) {},
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: setCategory,
                        child: Container(
                          width: width / 2,
                          height: height / 100 * 5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: accentColor,
                          ),
                          child: Text(
                            'اضافة',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setCategory() async {
    setState(() {
      errorNameEn = false;
      errorNameAr = false;
    });
    category.nameEn = "123456";
    if (category.nameEn.isNotEmpty &&
        category.nameEn.length > 5 &&
        category.nameAr.isNotEmpty &&
        category.nameAr.length > 5) {
      progress(context: context, isLoading: true);
      bool result = await category.setCategory();
      progress(context: context, isLoading: false);
      if (result) {
        print(">>>>>>>>>>>>>>>>>>>>Done");
        category.products = [];
        Navigator.pop(context, category);
      } else {}
    } else {
      if (category.nameEn.isEmpty) {
        errorNEn = 'مطلوب الاسم بالانجليزي';
        errorNameEn = true;
      } else if (category.nameEn.length <= 5) {
        errorNEn = 'يجب ان يكون اكبر من 5 اخرف';
        errorNameEn = true;
      }

      if (category.nameAr.isEmpty) {
        errorNAr = 'مطلوب الاسم';
        errorNameAr = true;
      } else if (category.nameAr.length <= 5) {
        errorNAr = 'يجب ان يكون اكبر من 5 اخرف';
        errorNameAr = true;
      }

      setState(() {});
    }
  }
}
