import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/user.dart';

class Report {
  String id;
  String desc;
  String createdAt;
  User user = User();
  Report({
    this.id = '',
    this.desc = '',
    this.createdAt = '',
    this.user,
  });

  factory Report.fromJson(Map json) {
    return Report(
      id: json['report_id'],
      desc: json['message'],
      createdAt: json['created_at'],
      user: User.fromJson(json),
    );
  }

  Future<bool> setReport() async {
    http.Response response =
        await http.post("$domain/report/create.php", body: {
      "user_id": globalUser.id,
      "message": this.desc,
    });
    var res = json.decode(response.body);
    print(res);
    if (!res['error']) {
      return true;
    }
    return false;
  }

  Future<List<Report>> getAllReport() async {
    List<Report> reports = List();
    http.Response response = await http.post("$domain/report/read.php", body: {
      "report": "report",
    });
    var res = json.decode(response.body);
    print(res);
    List data = res['report'];
    for (var item in data) {
      reports.add(Report.fromJson(item));
    }
    return reports;
  }

}
Future<List<Report>> getReportByUserId() async {
  List<Report> reports = List();
  http.Response response = await http.post("$domain/report/readByUserId.php", body: {
    "user_id": globalUser.id,
  });
  var res = json.decode(response.body);
  print(res);
  List data = res['report'];
  for (var item in data) {
    reports.add(Report.fromJson(item));
  }
  return reports;
}
