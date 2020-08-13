import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/loginData/forgotPssword.dart';
import 'package:burgernook/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'loginScreen.dart';

class NewPassword extends StatefulWidget {
  RecoveryPassword recoveryPassword;

  NewPassword(this.recoveryPassword);

  @override
  NewPasswordScreeState createState() => NewPasswordScreeState();
}

class NewPasswordScreeState extends State<NewPassword> {
  var height;
  var width;

  bool errorPassword = false;

  String errorPass = '';
  FocusNode focusNodePass_R = FocusNode();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20, // height / 100 * 2,
                right: 0,
                left: 0,
                child: Logo(),
              ),
              Positioned(
                top: height / 100 * 40,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget.recoveryPassword.message.isNotEmpty
                          ? Text(
                              "${widget.recoveryPassword.message}",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: accentColor, fontSize: 20),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            errorText: errorPassword ? errorPass : null,
                            prefixIcon: Icon(Icons.lock),
                            //'ادخل البريد الاكتروني او رقم الهاتف',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        style: TextStyle(
                          fontFamily: "",
                        ),

                        onChanged: (input) {
                          widget.recoveryPassword.password = input;
                        },
                        onSubmitted: (input) {
                          FocusScope.of(context)
                              .requestFocus(focusNodePass_R);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      TextField(
                        focusNode: focusNodePass_R,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: errorPassword ? errorPass : null,
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Re-enter your password',
                            //'ادخل البريد الاكتروني او رقم الهاتف',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        style: TextStyle(
                          fontFamily: "",
                        ),

                        onChanged: (input) {
                          widget.recoveryPassword.password_r = input;
                        },
                        onSubmitted: (input) {},
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: newPassword,
                        child: Container(
                          width: width / 2.5,
                          height: height / 100 * 5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: accentColor,
                          ),
                          child: Text(
                            'Submit',
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

  void newPassword() async {
    setState(() {
      errorPassword = false;
    });
    if (widget.recoveryPassword.password.isNotEmpty &&
        (widget.recoveryPassword.password ==
            widget.recoveryPassword.password_r)) {
      progress(context: context, isLoading: true);

      bool isDone = await widget.recoveryPassword.myNewPassword();
      if (isDone) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {}
    } else {
      if (widget.recoveryPassword.password.isEmpty) {
        errorPassword = true;
        errorPass = 'Password Is Required';
      }
      if (widget.recoveryPassword.password !=
          widget.recoveryPassword.password_r) {
        errorPassword = true;
        errorPass = 'Confirm the password';
      }
      setState(() {});
    }
  }
}
