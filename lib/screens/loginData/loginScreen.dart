import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/models/loginData/login.dart';
import 'package:burgernook/screens/delivery/deliveryScreen.dart';
import 'package:burgernook/screens/employee/employeeScreen.dart';
import 'package:burgernook/screens/owner/ownerScreen.dart';
import 'package:burgernook/widgets/logo.dart';
import '../../database/globle.dart';
import 'forgotPassword.dart';
import 'registerScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Login login = Login();

  bool errorUser = false;
  bool errorPassword = false;

  String errorU = '';
  String errorP = '';

  var height;
  var width;

  bool obscureTextValue = true;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: accentW,
      appBar: AppBar(
        title: Text(
          appLocalizations.translate("sign in"), //  'تسجيل الدخول',
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height - 100,
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
                top: 150, // height / 100 * 2,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: width,
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          appLocalizations.translate("you have an account ?"),
                          //  "لديك حساب ؟",
                          style: TextStyle(

                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorText: errorUser ? errorU : null,
                            prefixIcon: Icon(Icons.email),
                            labelText: appLocalizations
                                .translate("Enter your email or phone number"),
                            //'ادخل البريد الاكتروني او رقم الهاتف',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        style: TextStyle(  fontFamily: "",),
                        onChanged: (input) {
                          login.userName = input;
                        },
                        onSubmitted: (input) {
                          setState(() {
                            errorUser = false;
                            errorPassword = false;
                          });
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        focusNode: focusNode,
                        obscureText: obscureTextValue,
                        decoration: InputDecoration(
                          errorText: errorPassword ? errorP : null,
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
                          // 'كلمة المرور',
                          labelStyle: TextStyle(
                            fontFamily: "GE_Dinar_One_Light",
                          ),
                        ),
                        onChanged: (input) {
                          login.password = input;
                        },
                        onSubmitted: (input) {
                          setLogin();
                        },
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      InkWell(
                        onTap: setLogin,
                        child: Container(
                          width: width / 1.3,
                          height: height / 100 * 5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: accentColor,
                          ),
                          child: Text(
                            appLocalizations.translate("sign in"),
                            //  'تسجيل الدخول',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: Text(
                                appLocalizations
                                    .translate("Forgot your password ?"),
                                // 'نسيت كلمة المرور ؟',
                                style: TextStyle(
                                  fontFamily: "GE_Dinar_One_Light",
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
                                appLocalizations
                                    .translate("Register a new user?"),
                                //   'تسجيل مستخدم جديد؟',
                                style: TextStyle(
                                  color: accentColor,
                                  fontFamily: "GE_Dinar_One_Light",
                                ),
                              ),
                            ),
                          ],
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

  void setLogin() async {
    if (connected) {
      setState(() {
        errorUser = false;
        errorPassword = false;
      });
      if (login.userName.isNotEmpty &&
          login.password.isNotEmpty &&
          login.password.length > 4) {
        progress(context: context, isLoading: true);
        bool _isLogin = await login.setLogin();
        progress(context: context, isLoading: false);

        if (_isLogin) {
          print("BoooooooooooooM");
          if (isOwner) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => OwnerScreen()));
          } else if (isDelivery) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DeliveryScreen()));
          } else if (isEmployee) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EmployeeScreen()));
          } else if (isUser) {
            print("BoooooooisUserooooooM");
            Navigator.pop(context);
          }
          //   Navigator.pushReplacementNamed(context, '/HomeStudent');
          // print("Login");
        } else {
          switch (login.error) {
            case 'emailORPhoneNumber':
              errorUser = true;
              errorU = AppLocalizations.of(context).translate(
                  "This account is not already registered"); //'هذا الحساب غير مسجل من قبل';
              break;
            case 'password':
              errorPassword = true;
              errorP = AppLocalizations.of(context).translate(
                  "The password is incorrect"); //'كلمة المرور غير صحيحة';
              break;
            case 'notUserOrDelivery':
              errorPassword = true;
              errorP = AppLocalizations.of(context)
                  .translate("This account is not a customer or delivery"); //'كل
              errorUser = true;
              errorU = AppLocalizations.of(context).translate(
                  "This account is not a customer or delivery"); //'هذا الحساب غير مسجل من قبل';مة المرور غير صحيحة';
              break;
          }
          setState(() {});
        }
      } else {
        if (login.userName.isEmpty) {
          errorUser = true;
          errorU = AppLocalizations.of(context).translate(
              "Email or phone number is required"); //'اليريد الاكتروني او رقم الهاتف مطلوب';
        }
        /*else if (!login.userName.contains("@")) {
        errorUser = true;
        errorU = 'Make Sure This Email Is Correct';
      }*/
        if (login.password.isEmpty) {
          errorPassword = true;
          errorP = AppLocalizations.of(context)
              .translate("Password is required"); //'كلمة المرور مطلوبة';
        } else if (login.password.length <= 4) {
          errorPassword = true;
          errorP = AppLocalizations.of(context).translate(
              "The password is incorrect"); //'كلمة المرور غير صحيحة';
        }

        setState(() {});
      }
    } else {
      notConnected(context: context);
    }
  }
}
