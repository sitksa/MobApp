import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:burgernook/screens/owner/addEmployee.dart';

class AllEmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenScreeState createState() => _EmployeeScreenScreeState();
}

class _EmployeeScreenScreeState extends State<AllEmployeeScreen> {
  List<User> users = List();
  bool loading = true;

  _getUsers() async {
    if (connected) {
      setState(() {
        loading = true;
      });
      users = await User().getAllUsersByJobID(jobID: '2');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("الموظفين"),
      ),
      body: loading
          ? myCircularProgressIndicator()
          : ListView(
              children: users.map((User user) {
              return Card(
                  child: ListTile(
                leading: Container(
                    margin: EdgeInsets.all(5),
                    child: Image.asset("assets/empoloyee.png")),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("الاسم : ${user.fullName}"),
                    Text("رقم الهاتف : ${user.phoneNumber}"),
                    Text("كلمة المرور : ${user.password}"),
                  ],
                ),
              ));
            }).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEmployee(
                        employeeJobId: '2',
                      ))).then((value) {
            if (value != null) {
              setState(() {
                users.insert(0, value);
              });
            }
          });
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
