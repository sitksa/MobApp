import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/loginData/register.dart';
import 'package:burgernook/models/user/user.dart';

class AddEmployee extends StatefulWidget {
  String employeeJobId;

  AddEmployee({this.employeeJobId});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<AddEmployee> {
  bool errorName = false;
  bool errorPhone = false;
  bool errorPassword = false;

  String _path = '';

  String errorN = '';
  String errorP = '';
  String errorPass = '';

  Register register = Register(
    user: User(),
    error: '',
  );
  var height;
  var width;
  bool obscureTextValue = true;

  FocusNode focusNodeP = FocusNode();
  FocusNode focusNodePass = FocusNode();

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
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorName ? errorN : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            prefixIcon: Icon(Icons.person),
                            labelText: 'ادخل الاسم بالكامل'),
                        onChanged: (input) {
                          register.user.fullName = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context).requestFocus(focusNodeP);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        focusNode: focusNodeP,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            errorText: errorPhone ? errorP : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
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
                            labelText: 'ادخل رقم الهاتف'),
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
                        focusNode: focusNodePass,
                        obscureText: obscureTextValue,
                        decoration: InputDecoration(
                            errorText: errorPassword ? errorPass : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
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
                            labelText: 'كلمة المرور'),
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

  void setRegister() async {
    setState(() {
      errorName = false;
      errorPhone = false;
      errorPassword = false;
    });
    if (register.user.fullName.isNotEmpty &&
        register.user.fullName.length > 5 &&
        register.user.phoneNumber.isNotEmpty &&
        register.user.phoneNumber.length > 8 &&
        register.user.password.isNotEmpty &&
        register.user.password.length > 5) {
      register.user.email = register.user.fullName;
      progress(context: context, isLoading: true);
      register.user.employeeJob = widget.employeeJobId;
      bool result = await register.setRegister();
      progress(context: context, isLoading: false);
      if (result) {
        print(">>>>>>>>>>>>>>>>>>>>Done");
        Navigator.pop(context, register.user);
      } else {
        switch (register.error) {
          case "phone":
            errorPhone = true;
            errorP = 'رقم الهاتف مستخدم من قبل';
            break;
        }
        setState(() {});
      }
    } else {
      if (register.user.fullName.isEmpty) {
        errorName = true;
        errorN = 'مطلوب الاسم يالكامل';
      } else if (register.user.fullName.length <= 5) {
        errorName = true;
        errorN = 'يجب ان يكون اكبر من 5 احرف';
      }

      if (register.user.phoneNumber.isEmpty) {
        errorPhone = true;
        errorP = 'مطلوب ادخال رقم الهاتف';
      } else if (register.user.phoneNumber.length <= 8) {
        errorPhone = true;
        errorP = 'رقم الهاتف هذا غير صحيح';
      }
      if (register.user.password.isEmpty) {
        errorPassword = true;
        errorPass = 'مطلوب ادخال كلمة المرور';
      } else if (register.user.password.length <= 5) {
        errorPassword = true;
        errorPass = 'يجب ان يكون اكبر من 5 احرف';
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
