import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/report.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenScreeState createState() => _ReportsScreenScreeState();
}

class _ReportsScreenScreeState extends State<ReportsScreen> {
  List<Report> reports = List();
  bool loading = true;

  _getReports() async {
    if (connected) {
      setState(() {
        loading = true;
      });
      reports = await Report().getAllReport();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("الشكاوي"),
      ),
      body: loading
          ? myCircularProgressIndicator()
          : ListView(
              children: reports.map((Report report) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Text("الاسم : "),
                            Text(report.user.fullName),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("رقم الهاتف : "),
                                Text(report.user.phoneNumber),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("البريد الالكتروني : "),
                                Text(report.user.email),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("التاريخ : "),
                                Text(report.createdAt),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("الشكوي : "),
                                Flexible(
                                  child: Text(
                                      '${report.desc}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
