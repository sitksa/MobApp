import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/database/sharedPreferences.dart';
import 'package:burgernook/models/user/user.dart';

class Login {
  String userName;
  String password;
  String error;

  Login({this.userName = '', this.password = ''});

  Future<bool> setLogin() async {
    http.Response response = await http.post("$domain/user/login.php", body: {
      "emailORPhoneNumber": this.userName,
      "password": this.password,
    });
    print(response.body);
    //zalat@sitksa1.com
    var res = json.decode(response.body);
    if (!res['error']) {
      User _user = User.fromJson(res['user_info']);
      print(_user.employeeJob);
      if (_user.employeeJob == "1" || _user.employeeJob == "2") {
        this.error = "notUserOrDelivery";
        return false;
      }
      globalUser = await MySharedPreferences().setUser(user: _user);
      await check();
      return true;
    } else {
      this.error = res['message'];
      return false;
    }
  }
}
