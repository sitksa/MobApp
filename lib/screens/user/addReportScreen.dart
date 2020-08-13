import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/report.dart';
import 'package:burgernook/screens/loginData/loginScreen.dart';

class AddReportScreen extends StatefulWidget {
  @override
  AaddReportScreenScreeState createState() => AaddReportScreenScreeState();
}

class AaddReportScreenScreeState extends State<AddReportScreen> {
  Report report = Report(
    desc: '',
  );
  var height;
  var width;

  bool errorDesc = false;

  String errorE = '';

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(appLocalizations.translate("Make a complaint")),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: TextField(
              maxLines: 20,
              maxLength: 900,
              minLines: 4,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: errorDesc ? errorE : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                prefixIcon: Icon(Icons.report),
                labelText: appLocalizations.translate('Explain the complaint, please'),
              ),
              onChanged: (input) {
                report.desc = input;
              },
              onSubmitted: (input) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: setRecovery,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 80),
                alignment: Alignment.center,
                child: Text(
                  appLocalizations.translate('Make a complaint'),
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
    );
  }

  void setRecovery() async {
    if (isLogin) {
      if (isUser) {
        if (connected) {
          setState(() {
            errorDesc = false;
          });
          if (report.desc.isNotEmpty && report.desc.length > 8) {
            if (connected) {
              progress(context: context, isLoading: true);
              bool isDone = await report.setReport();
              progress(context: context, isLoading: false);
              if (isDone) {
                Navigator.pop(context);
              } else {}
            } else {
              notConnected(context: context);
              print("not connected");
            }
          } else {
            if (report.desc.isEmpty) {
              errorDesc = true;
              errorE =
                  AppLocalizations.of(context).translate('Explain the complaint, please');
            } else if (report.desc.length <= 8) {
              errorDesc = true;
              errorE = AppLocalizations.of(context)
                  .translate('Please explain more details');
            }
            setState(() {});
          }
        } else {
          notConnected(context: context);
        }
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
