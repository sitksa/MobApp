import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/loginData/forgotPssword.dart';
import 'package:burgernook/widgets/logo.dart';
import 'package:flutter/material.dart';

import 'newPassword.dart';

class VerifyCode extends StatefulWidget {
  RecoveryPassword recoveryPassword;

  VerifyCode(this.recoveryPassword);

  @override
  _VerifyCodeScreeState createState() => _VerifyCodeScreeState();
}

class _VerifyCodeScreeState extends State<VerifyCode> {
  var height;
  var width;
  bool errorCode = false;
  String errorC = '';

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
                   /*    widget.recoveryPassword.code_.isNotEmpty
                          ? Text(
                              widget.recoveryPassword.code_,
                              style:
                                  TextStyle(color: accentColor, fontSize: 20,fontFamily: "1"),
                            )
                          : Container(),*/
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(
                          fontFamily: "",
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.code),
                            errorText: errorCode ? errorC : null,
                            hintText: 'Code',
                            labelStyle: TextStyle(
                              fontFamily: "GE_Dinar_One_Light",
                            )),
                        onChanged: (input) {
                          widget.recoveryPassword.code = input;
                        },
                        onSubmitted: (input) {},
                      ),

                      SizedBox(
                        height: height / 15,
                      ),
                      InkWell(
                        onTap: verifyCode,
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

  void verifyCode() async {
    setState(() {
      errorCode = false;
    });
    if (widget.recoveryPassword.code.isNotEmpty) {
      progress(context: context, isLoading: true);

      bool isDone = await widget.recoveryPassword.verifyCode();
      progress(context: context, isLoading: false);
      if (isDone) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewPassword(widget.recoveryPassword)));
      } else {
        setState(() {});
      }
    } else {
      if (widget.recoveryPassword.code.isEmpty) {
        errorCode = true;
        errorC = 'code Is Required';
      }
      setState(() {});
    }
  }
}
