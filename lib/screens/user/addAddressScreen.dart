import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:burgernook/models/user/address.dart';

import '../../database/globle.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _RAddAddressScreenState createState() => _RAddAddressScreenState();
}

class _RAddAddressScreenState extends State<AddAddressScreen> {
  bool errorName = false;
  bool errorAddress = false;

  String errorN = '';
  String errorA = '';

  var height;
  var width;

  Address address = Address();
  FocusNode focusNodeA = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.translate("Add an address"), //"اضافة عنوان",
        ),
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
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: appLocalizations.translate("Home, work"),
                          //"المنزل , العمل",
                          errorText: errorName ? errorN : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: Icon(Icons.title),
                          labelText: appLocalizations
                              .translate("name of the place"), //'اسم المكان',
                        ),
                        onChanged: (input) {
                          address.addressTitle = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeA);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        focusNode: focusNodeA,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorText: errorAddress ? errorA : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: Icon(Icons.details),
                          labelText: appLocalizations.translate(
                              "Address details"), // 'تفاصيل العنوان',
                        ),
                        onChanged: (input) {
                          address.address = input;
                        },
                        onSubmitted: (input) {},
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: address.addressInMap.isNotEmpty
                            ? Text("${address.addressInMap}")
                            : Text(
                                appLocalizations.translate(
                                    "Enter the GPS location"), //"ادخال موقع المكان GPS",
                              ),
                        trailing: Icon(
                          Icons.location_on,
                          color: address.addressInMap.isNotEmpty
                              ? Colors.green
                              : null,
                        ),
                        onTap: () {
                          getLocation();
                        },
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: setRegister,
                        child: Container(
                          width: width / 2,
                          height: height / 100 * 5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: accentColor,
                          ),
                          child: Text(
                            appLocalizations.translate("Add an address"),
                            //  'اضف عنوان',
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

  getLocation() async {
    try {
      progress(context: context, isLoading: true);
      await Location().getLocation();
      await Location().getLocation().then((LocationData currentLocation) async {
        address.latitude = currentLocation.latitude.toString();
        address.longitude = currentLocation.longitude.toString();

        address.addressInMap = await findAddresses(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude);

        print(currentLocation.latitude);
        print(currentLocation.longitude);
      });
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      print('currentLocation = null;');
    }
    progress(context: context, isLoading: false);
  }

  void setRegister() async {
    setState(() {
      errorName = false;
      errorAddress = false;
    });

    if (address.addressTitle.isNotEmpty && address.address.isNotEmpty) {
      progress(context: context, isLoading: true);
      bool result = await address.setAddress();
      progress(context: context, isLoading: false);
      if (result) {
        print(">>>>>>>>>>>>>>>>>>>>Done");
        Navigator.pop(context, address);
      } else {
        switch (address.error) {
          case "phone":
            break;
          case "email":
            break;
        }
        setState(() {});
      }
    } else {
      if (address.addressTitle.isEmpty) {
        errorName = true;
        errorN = AppLocalizations.of(context)
            .translate("Name required"); //'مطلوب الاسم المكان';
      }
      /*else if (address.addressTitle.length <= 5) {
        errorName = true;
        errorN = 'يجب ان يكون اكبر من 5 احرف';
      }*/
      if (address.addressTitle.isEmpty) {
        errorAddress = true;
        errorA = AppLocalizations.of(context)
            .translate("Title details are required"); // 'مطلوب تفاصيل العموان';
      }

      setState(() {});
    }
  }
}
