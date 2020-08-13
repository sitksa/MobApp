import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/user.dart';

class Register {
  User user;
  String error;

  Register({
    this.user,
    this.error,
  });

  Future<bool> setRegister() async {
    var sss = '';
    try {
      print(this.user.fullName);
      print(this.user.phoneNumber);
      print(this.user.email);
      print(this.user.password);
      print(this.user.employeeJob);
      http.Response response =
          await http.post("$domain/user/register.php", body: this.user.toMap());
      sss = response.body;
      var res = json.decode(response.body);
      print(res);
      if (!res['error']) {
        return true;
      } else {
        this.error = res['message'];
        return false;
      }
    } catch (e) {
      this.error = sss;
      return false;
    }
  }
}
