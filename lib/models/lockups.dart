import 'dart:convert';

import 'package:burgernook/database/globle.dart';
import 'package:http/http.dart' as http;

class Lockups {
  String lockups_id;
  String code_name;
  String name;

  Lockups({
    this.lockups_id,
    this.code_name,
    this.name,
  });

  factory Lockups.fromJson(json) {
    return Lockups(
      lockups_id: json['lockups_id'],
      code_name: json['code_name'],
      name: json['name'],
    );
  }
}

Future<List<Lockups>> getLockups(String _code_name) async {
  List<Lockups> lockups = List();
  http.Response response =
      await http.post("$domain/lockups/readByCodeName.php", body: {
    "code_name": _code_name,
  });
  var res = json.decode(response.body);
  List data = res['lockups'];
  print(res);
  globalLockup = Lockups.fromJson(data[0]);
  for (var item in data) {
   // lockups.add(Lockups.fromJson(item));
  }

  return lockups;
}
