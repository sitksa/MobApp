import 'dart:async';
import 'dart:convert';

import 'package:burgernook/database/globle.dart';
import 'package:http/http.dart' as http;


class RecoveryPassword {
  String created_at;
  String email;
  String phone_number;
  String code;
  String code_;
  String message;
  String user_id;
  String password;
  String password_r;

  RecoveryPassword(
      {this.created_at = '',
        this.email = '',
        this.phone_number = '',
        this.code = '',
        this.code_ = '',
        this.user_id = '',
        this.message = '',
        this.password = '',
        this.password_r = '',
      });

  Future<bool> recoveryP() async {
    http.Response response =
    await http.post("$domain/user/forgotPassword.php", body: {
      "email": this.email,
      "phone_number": this.phone_number,
    });
    print(response.body);
    var res = json.decode(response.body);

   // print(res);

    if (!res['error']) {
      this.message = res['message'];
      this.code_ = res['code'];
      this.created_at = res['created_at'];
      this.user_id = res['user_id'];
      return true;
    } else {
      this.message = res['message'];
      return false;
    }
  }

  Future<bool> verifyCode() async {
    print(this.created_at);
    print(this.code);
    print(this.user_id);
    http.Response response =
    await http.post("$domain/user/verifyCode.php", body: {
      "created_at": this.created_at,
      "code": this.code,
      "user_id": this.user_id,
    });
    var res = json.decode(response.body);
    print(response.body);
    print(res);
    if (!res['error']) {
      this.message = res['message'];
      return true;
    } else {
      this.message = res['message'];
      return false;
    }
  }
  Future<bool> myNewPassword() async {
    http.Response response =
    await http.post("$domain/user/newPassword.php", body: {
      "password": this.password,
      "user_id": this.user_id,
    });
    var res = json.decode(response.body);
    print(response.body);
    print(res);
    if (!res['error']) {
      this.message = res['message'];
      return true;
    } else {
      this.message = res['message'];
      return false;
    }
  }
}
