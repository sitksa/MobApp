import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/screens/user/addReportScreen.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/report.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenScreeState createState() => _ReportScreenScreeState();
}

class _ReportScreenScreeState extends State<ReportScreen> {
  List<Report> reports = List();
  bool isLoading = true;

  getReports() async {
    isLoading = true;
    setState(() {});
    reports = await getReportByUserId();

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isLogin && isUser) {
      getReports();
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(appLocalizations.translate("Complaints")),
        ),
        body: isLoading
            ? myCircularProgressIndicator()
            : ListView(
                children: reports.map((Report report) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                        color: accentW,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.4),
                              blurRadius: 3)
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text("${report.desc}"),
                          alignment: Alignment.topRight,
                        ),
                        Text(
                          "${report.createdAt}",
                          style: TextStyle(fontFamily: "arlrdbd"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddReportScreen())).then((value) => getReports());
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 80),
              alignment: Alignment.center,
              child: Text(
                appLocalizations.translate("Make a complaint"),// 'تقديم الشكوى',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }
}
