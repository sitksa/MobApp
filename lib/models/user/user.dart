import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';

class User {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  String password;
  String employeeJob;

  User({
    this.id = '0',
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.employeeJob = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      password: json['password']?.toString(),
      employeeJob: json['employee_job'],
    );
  }

  toMap() {
    return {
      "full_name": this.fullName,
      "phone_number": this.phoneNumber,
      "email": this.email,
      "password": this.password,
      "employee_job": this.employeeJob,
    };
  }

  Future<List<User>> getAllUsersByJobID({jobID}) async {
    List<User> users = List();
    http.Response response = await http
        .post("$domain/user/readByJobID.php", body: {"lockups_id": jobID});
    var res = json.decode(response.body);
    print(res);
    List data = res['user'];
    for (var item in data) {
      users.add(User.fromJson(item));
    }
    return users;
  }
}
