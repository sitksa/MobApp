import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/product.dart';

class EditProduct extends StatefulWidget {
  Product product;

  EditProduct({this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  TextEditingController textEditingControllerAr;
  TextEditingController textEditingControllerDesc;
  TextEditingController textEditingControllerPrice ;
  bool errorNameAr = false;
  bool errorNameDesc = false;
  bool errorPrice = false;

  String errorNAr = '';
  String errorNDesc= '';
  String errorNPrice = '';

  var height;
  var width;

  FocusNode focusNodeNAr = FocusNode();
  FocusNode focusNodeNPrice = FocusNode();
  FocusNode focusNodeNDesc = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    textEditingControllerAr = TextEditingController(text: widget.product.nameAr);
    textEditingControllerDesc = TextEditingController(text: widget.product.prduct_components);
   textEditingControllerPrice  = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("${widget.product.nameAr}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Image.network(
              '$domain/image/uploads/${widget.product.imageName}',
              height: MediaQuery.of(context).size.height / 3,
            ),
            SizedBox(
              height: height / 15,
            ),
            /*Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNodePrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: errorPrice ? errorNPrice : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'ادخل الاسم بالعربي'),
                onChanged: (input) {
                  price = input;
                },
                onSubmitted: (input) {},
              ),
            ),*/
            TextField(
              controller: textEditingControllerAr,
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
                widget.product.nameAr = input;
              },
              onSubmitted: (input) {
                FocusScope.of(context).requestFocus(focusNodeNPrice);
              },
            ),

            SizedBox(
              height: 15,
            ),
            TextField(
              controller: textEditingControllerPrice,
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
             //   widget. product.price = input;
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
              controller: textEditingControllerDesc,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  errorText: errorNameDesc ? errorNDesc : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.description),
                  labelText: 'الوصف'),
              onChanged: (input) {
                widget.product.prduct_components = input;
              },
              onSubmitted: (input) {
              },
            ),
            SizedBox(
              height: height / 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: updateProduct,
                child: Container(
                  width: width / 2,
                  height: height / 100 * 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: accentColor,
                  ),
                  child: Text(
                    'تم التعديل',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateProduct() async {
    setState(() {
      errorNameDesc = false;
      errorNameAr = false;
      errorPrice = false;
    });
    if (connected) {
      if (widget.product.prduct_components.isNotEmpty &&
          widget.product.prduct_components.length > 5 &&
          widget.product.nameAr.isNotEmpty &&
          widget.product.nameAr.length > 5
    ) {
        progress(context: context, isLoading: true);
        bool result = await  widget.product.update();
       progress(context: context, isLoading: false);
        if (result) {
          print(">>>>>>>>>>>>>>>>>>>>Done");
          Navigator.pop(context,  widget.product);
          //Navigator.pop(context,);
        } else {}
      } else {
        if ( widget.product.prduct_components.isEmpty) {
          errorNDesc = 'مطلوب الوصف';
          errorNameDesc = true;
        } else if ( widget.product.prduct_components.length <= 5) {
          errorNDesc = 'يجب ان يكون اكبر من 5 اخرف';
          errorNameDesc = true;
        }

        if ( widget.product.nameAr.isEmpty) {
          errorNAr = 'مطلوب الاسم';
          errorNameAr = true;
        } else if ( widget.product.nameAr.length <= 5) {
          errorNAr = 'يجب ان يكون اكبر من 5 اخرف';
          errorNameAr = true;
        }
//        if ( widget.product.price.isEmpty) {
//          errorNPrice = 'مطلوب السعر';
//          errorPrice = true;
//        }
        setState(() {});
      }
    } else {
      notConnected(context: context);
    }
  }

/*  void updateProduct() async {
    setState(() {
      errorNameDesc = false;
      errorNameAr = false;
      errorPrice = false;
    });
    if (price.isNotEmpty) {
      progress(context: context, isLoading: true);
      bool result = await widget.product.update(price: price);
      progress(context: context, isLoading: false);
      if (result) {
        widget.product.price = price;
        Navigator.pop(context, widget.product);
      }
    } else {
      errorNPrice = "يجب ادخل السعر";
      errorPrice = true;
    }
  }*/
}
