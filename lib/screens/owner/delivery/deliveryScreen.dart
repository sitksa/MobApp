import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:burgernook/screens/owner/addEmployee.dart';

class AllDeliveryScreen extends StatefulWidget {
  @override
  _EmployeeScreenScreeState createState() => _EmployeeScreenScreeState();
}

class _EmployeeScreenScreeState extends State<AllDeliveryScreen> {
  List<User> users = List();
  bool loading = true;

  _getUsers() async {
    if (connected) {
      setState(() {
        loading = true;
      });
      users = await User().getAllUsersByJobID(jobID: '4');
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
        title: Text("الدليفري"),
      ),
      body: loading
          ? myCircularProgressIndicator()
          : ListView(
              children: users.map((User user) {
              return Card(
                  child: ListTile(
                leading: Container(
                    margin: EdgeInsets.all(5),
                    child: Icon(
                      Icons.directions_bike,
                      color: Colors.black,
                      size: 35,
                    )),
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
                        employeeJobId: '4',
                      ))).then((value) {
            if (value != null) {
              setState(() {
                users.insert(0, value);
              });
              getAllDeliveries();
            }
          });
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
