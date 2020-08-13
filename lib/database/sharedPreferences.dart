import 'dart:ui';

import 'package:burgernook/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  Future<bool> setLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLogin', false);
    await sharedPreferences.setBool('isDelivery', false);
    await sharedPreferences.setBool('isEmployee', false);
    await sharedPreferences.setBool('isOwner', false);
    await sharedPreferences.setBool('isUser', false);
    return true;
  }

  Future<bool> isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isLogin') == null
        ? false
        : sharedPreferences.getBool('isLogin');
  }

  Future<bool> isDelivery() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isDelivery') == null
        ? false
        : sharedPreferences.getBool('isDelivery');
  }

  Future<bool> isEmployee() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isEmployee') == null
        ? false
        : sharedPreferences.getBool('isEmployee');
  }

  Future<bool> isOwner() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isOwner') == null
        ? false
        : sharedPreferences.getBool('isOwner');
  }

  Future<bool> isUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isUser') == null
        ? false
        : sharedPreferences.getBool('isUser');
  }

  Future<User> setUser({User user}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('id', user.id);
    sharedPreferences.setString('fullName', user.fullName);
    sharedPreferences.setString('phoneNumber', user.phoneNumber);
    sharedPreferences.setString('email', user.email);
    sharedPreferences.setString('employeeJob', user.employeeJob);
    sharedPreferences.setBool('isLogin', true);
    switch (user.employeeJob) {
      case "1":
        print(">>>>>>>>>>>>>>>>isOwner");
        sharedPreferences.setBool('isOwner', true);
        break;
      case "2":
        print(">>>>>>>>>>>>>>>>isEmployee");
        sharedPreferences.setBool('isEmployee', true);
        break;
      case "4":
        print(">>>>>>>>>>>>>>>>isDelivery");
        sharedPreferences.setBool('isDelivery', true);
        break;
      case "5":
        print(">>>>>>>>>>>>>>>>isUser");
        sharedPreferences.setBool('isUser', true);
        break;
    }
    return user;
  }

  Future<User> getUser() async {
    User user = User();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    user.id = sharedPreferences.getString('id');
    user.fullName = sharedPreferences.getString('fullName');
    user.phoneNumber = sharedPreferences.getString('phoneNumber');
    user.email = sharedPreferences.getString('email');
    user.employeeJob = sharedPreferences.getString('employeeJob');
    return user;
  }
  Future<Locale> getProviderLangSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('languageCode') == null
        ? Locale("ar")
        : Locale(sharedPreferences.getString('languageCode'));
  }

  Future<void> saveProviderLangSharedPref({languageCode}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('languageCode', languageCode);
  }
}
