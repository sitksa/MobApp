import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burgernook/models/loginData/register.dart';
import 'package:burgernook/models/user/user.dart';

import '../../database/globle.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool errorName = false;
  bool errorEmail = false;
  bool errorPhone = false;
  bool errorPassword = false;

  String _path = '';

  String errorN = '';
  String errorE = '';
  String errorP = '';
  String errorPass = '';

  Register register = Register(
    user: User(),
    error: '',
  );
  var height;
  var width;
  bool obscureTextValue = true;

  FocusNode focusNodeM = FocusNode();
  FocusNode focusNodeP = FocusNode();
  FocusNode focusNodePass = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.translate("Register"), //"التسجيل",
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
                top: 5, // height / 100 * 2,
                right: 0,
                left: 0,
                child: Container(height: 150, child: Logo()),
              ),
              Positioned(
                top: 150,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorName ? errorN : null,
                            prefixIcon: Icon(Icons.person),
                            labelText: appLocalizations.translate(
                                "Enter Full name"), //'ادخل الاسم بالكامل',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        onChanged: (input) {
                          register.user.fullName = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeM);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        focusNode: focusNodeM,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorText: errorEmail ? errorE : null,
                            prefixIcon: Icon(Icons.email),
                            labelText: appLocalizations.translate(
                                "Enter the email"), //'ادخل البريد الاكتروني',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        onChanged: (input) {
                          register.user.email = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeP);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        focusNode: focusNodeP,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            errorText: errorPhone ? errorP : null,
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureTextValue = !obscureTextValue;
                                });
                              },
                              child: Icon(
                                Icons.phone_android,
                              ),
                            ),
                            labelText: appLocalizations.translate(
                                "Enter a phone number"), //'ادخل رقم الهاتف',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        onChanged: (input) {
                          register.user.phoneNumber = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodePass);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        focusNode: focusNodePass,
                        obscureText: obscureTextValue,
                        decoration: InputDecoration(
                            errorText: errorPassword ? errorPass : null,

                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(100)),
                            //   borderSide:
                            //       BorderSide(width: 1, color: mainColor),
                            // ),
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureTextValue = !obscureTextValue;
                                });
                              },
                              child: obscureTextValue
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                            labelText: appLocalizations.translate("password"),
                            //'كلمة المرور',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        onChanged: (input) {
                          register.user.password = input;
                        },
                        onSubmitted: (input) {},
                      ),
                      /*  SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text(
                            ""),
                        onTap: () {
                          getLocation();
                        },
                      ),*/
                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: setRegister,
                        child: Container(
                          width: width / 1.3,
                          height: height / 100 * 5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: accentColor,
                          ),
                          child: Text(
                            appLocalizations.translate("Register"),
                            // 'سجل الان',
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

  void setRegister() async {
    setState(() {
      errorName = false;
      errorEmail = false;
      errorPhone = false;
      errorPassword = false;
    });
    if (register.user.fullName.isNotEmpty &&
        register.user.fullName.length > 5 &&
        register.user.email.isNotEmpty &&
        register.user.email.contains('@') &&
        register.user.phoneNumber.isNotEmpty &&
        register.user.phoneNumber.length > 8 &&
        register.user.password.isNotEmpty &&
        register.user.password.length > 5&&connected) {
      progress(context: context, isLoading: true);
      register.user.employeeJob = "5";
      bool result = await register.setRegister();
      ackAlert(context: context,content: register.error,title: "101",textButton: "نعم");
      progress(context: context, isLoading: false);
      if (result) {
        print(">>>>>>>>>>>>>>>>>>>>Done");
        Navigator.pop(context);
        done(context: context);
      } else {
        ackAlert(context: context,content: register.error,title: "504",textButton: "نعم");
        switch (register.error) {
          case "phone":
            errorPhone = true;
            errorP = AppLocalizations.of(context).translate(
                "The phone number is already in use"); //'رقم الهاتف مستخدم من قبل';
            break;
          case "email":
            errorEmail = true;
            errorE = AppLocalizations.of(context).translate(
                "This email is already in use"); //'هذا البريد الالكتروني مستخدم من قبل';
            break;


        }
        setState(() {});
      }
    } else {
      if (!connected) {
        notConnected(context: context);
      }if (register.user.fullName.isEmpty) {
        errorName = true;
        errorN = AppLocalizations.of(context)
            .translate("Full name is required"); // 'مطلوب الاسم يالكامل';
      } else if (register.user.fullName.length <= 5) {
        errorName = true;
        errorN = AppLocalizations.of(context).translate(
            "It must be greater than 5 characters"); //'يجب ان يكون اكبر من 5 احرف';
      }
      if (register.user.email.isEmpty) {
        errorEmail = true;
        errorE = AppLocalizations.of(context)
            .translate("Email is required"); //'مطلوب البريد الالكتروني';
      } else if (!register.user.email.contains('@')) {
        errorEmail = true;
        errorE = AppLocalizations.of(context).translate(
            "This email is incorrect"); //'هذا البريد الالكتروني غير صحيح';
      }
      if (register.user.phoneNumber.isEmpty) {
        errorPhone = true;
        errorP = AppLocalizations.of(context)
            .translate("Phone number is required"); //'مطلوب ادخال رقم الهاتف';
      } else if (register.user.phoneNumber.length <= 8) {
        errorPhone = true;
        errorP = AppLocalizations.of(context).translate(
            "This phone number is incorrect"); //'رقم الهاتف هذا غير صحيح';
      }
      if (register.user.password.isEmpty) {
        errorPassword = true;
        errorPass = AppLocalizations.of(context)
            .translate("Password is required"); //'مطلوب ادخال كلمة المرور';
      } else if (register.user.password.length <= 5) {
        errorPassword = true;
        errorPass = AppLocalizations.of(context).translate(
            "It must be greater than 5 characters"); //'يجب ان يكون اكبر من 5 احرف';
      }
      setState(() {});
    }
  }

  getLocation() async {
    /* try {
      await Location().getLocation().then((LocationData currentLocation) {
        register.latitude = currentLocation.latitude.toString();
        register.longitude = currentLocation.longitude.toString();
        print(currentLocation.latitude);
        print(currentLocation.longitude);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        //error = 'Permission denied';
        print('Permission denied');
      }
      print('currentLocation = null;');
    }*/
  }
}
