import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/category.dart';
import 'package:burgernook/models/product.dart';

class AddProduct extends StatefulWidget {
  Category category = Category();

  AddProduct({this.category});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Product product = Product();

  bool errorNameAr = false;
  bool errorNameDesc = false;
  bool errorPrice = false;

  String errorNAr = '';
  String errorNDesc= '';
  String errorNPrice = '';

  var height;
  var width;

  FocusNode focusNodeNAr = FocusNode();
  FocusNode focusNodeNDesc = FocusNode();
  FocusNode focusNodeNPrice = FocusNode();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافة عنصر"),
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
                      InkWell(
                        onTap: () async {
                          await chooseImage(context);
                        },
                        child: product.imageFile == null
                            ? Container(
                                height: MediaQuery.of(context).size.width / 3,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 20,
                                ),
                                child: Image.asset("assets/frame.png"),
                              )
                            : Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 20,
                                        ),
                                        child: Image.file(product.imageFile)),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            product.imageFile = null;
                                          });
                                        }),
                                  )
                                ],
                              ),
                      ),
                  /*    TextField(
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
                          product.nameEn = input;
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
                          product.nameAr = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeNPrice);
                        },
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        focusNode: focusNodeNPrice,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorText: errorPrice ? errorNPrice : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            prefixIcon: Icon(Icons.monetization_on),
                            labelText: 'ادخل السعر'),
                        onChanged: (input) {
                         // product.price = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeNDesc);},
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 5000,
                        focusNode: focusNodeNDesc,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorNameDesc ? errorNDesc : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.description),
                            labelText: 'الوصف'),
                        onChanged: (input) {
                          product.prduct_components = input;
                        },
                        onSubmitted: (input) {
                        },
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: _setProduct,
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

  void _setProduct() async {
    setState(() {
      errorNameDesc = false;
      errorNameAr = false;
      errorPrice = false;
    });
    if (connected) {
      if (product.prduct_components.isNotEmpty &&
          product.prduct_components.length > 5 &&
          product.nameAr.isNotEmpty &&
          product.nameAr.length > 5 &&

          product.imageFile != null) {
        product.categoryId = widget.category.id;
        progress(context: context, isLoading: true);
        bool result = await product.setProduct();
        progress(context: context, isLoading: false);
        if (result) {
          print(">>>>>>>>>>>>>>>>>>>>Done");
          Navigator.pop(context, product);
        } else {}
      } else {
        if (product.prduct_components.isEmpty) {
          errorNDesc = 'مطلوب الوصف';
          errorNameDesc = true;
        } else if (product.prduct_components.length <= 5) {
          errorNDesc = 'يجب ان يكون اكبر من 5 اخرف';
          errorNameDesc = true;
        }

        if (product.nameAr.isEmpty) {
          errorNAr = 'مطلوب الاسم';
          errorNameAr = true;
        } else if (product.nameAr.length <= 5) {
          errorNAr = 'يجب ان يكون اكبر من 5 اخرف';
          errorNameAr = true;
        }
//        if (product.price.isEmpty) {
//          errorNPrice = 'مطلوب السعر';
//          errorPrice = true;
//        }
        setState(() {});
      }
    } else {
      notConnected(context: context);
    }
  }

  Future<void> chooseImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton.icon(
                  label: Text('المعرض'),
                  icon: Icon(
                    Icons.image,
                    size: 35,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File _file = await getImageGallery();
                    if (_file != null) {
                      product.imageFile = _file;
                      print(product.imageFile.path);
                      setState(() {});
                    }
                  }),
              FlatButton.icon(
                  label: Text('الكاميرة'),
                  icon: Icon(
                    Icons.camera_alt,
                    size: 35,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File _file = await getImageCamera();
                    if (_file != null) {
                      product.imageFile = _file;
                      print(product.imageFile.path);
                      setState(() {});
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
