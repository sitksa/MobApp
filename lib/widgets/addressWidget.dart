import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/address.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/screens/loginData/loginScreen.dart';
import 'package:burgernook/screens/user/addAddressScreen.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatefulWidget {
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  List<Address> address = List();
  bool isLoading = true;
  int value = 1000000;

  _getAddress() async {
    if (connected) {
      setState(() {
        isLoading = true;
      });
      address = await Address().getAddress();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Basket>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: accentW,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: isLoading
            ? myCircularProgressIndicator()
            : Column(
                children: <Widget>[
                  address.isEmpty
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(8.0),

                          ///margin: EdgeInsets.only(right: 20, top: 0),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'اختار العنوان*',
                            style: TextStyle(
                              color: accentColor5,
                            ),
                          ),
                        ),
                  Container(
                    height: 56 * address.length.toDouble(),
                    child: ListView.builder(
                      itemCount: address.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          value: index,
                          groupValue: value,
                          onChanged: (ind) => setState(() {
                            value = ind;
                            basket.setAddress(address[index]);
                          }),
                          title: Text("${address[index].addressTitle}"),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (isLogin) {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddressScreen()))
                            .then((_address) {
                          if (_address != null) {
                            setState(() {
                              address.add(_address);
                            });
                          }
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'اضافة عنوان',
                            style: TextStyle(color: accentColor5, fontSize: 16),
                          ),
                          Icon(
                            Icons.add_circle,
                            color: accentColor5,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
