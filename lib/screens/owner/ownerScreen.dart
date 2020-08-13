import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/database/sharedPreferences.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:burgernook/screens/owner/category/allCategoryScreen.dart';
import 'package:burgernook/screens/owner/delivery/deliveryScreen.dart';
import 'package:burgernook/screens/owner/employee/employeeScreen.dart';
import 'package:burgernook/screens/owner/reportsScreen.dart';
import 'package:burgernook/screens/owner/sliders/slidersScreen.dart';
import 'package:burgernook/screens/owner/tabs/tabNewOrder.dart';
import 'package:burgernook/screens/owner/tabs/tabNotDelivered.dart';
import 'package:burgernook/screens/owner/tabs/tabReceived.dart';
import 'package:burgernook/screens/user/userScreen.dart';

class OwnerScreen extends StatefulWidget {
  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen>
    with SingleTickerProviderStateMixin {
  TabController tabcontroller;
  List<Order> _newOrders = List();
  List<Order> _receivedOrders = List();
  List<Order> _notDeliveredOrders = List();

  _getOrder() async {
    setState(() {});
    getNewOrders();
    getNotDeliveredOrders();
    getReceivedOrders();
  }

  getNewOrders() async {
    _newOrders.clear();
    _newOrders = await Order().getOrdersByStatusId(statusId: '6');
    loadingNewOrder = false;
    setState(() {});
  }

  getNotDeliveredOrders() async {
    _notDeliveredOrders.clear();
    _notDeliveredOrders = await Order().getOrdersByStatusId(statusId: '7');
    loadingReceived = false;
    setState(() {});
  }

  getReceivedOrders() async {
    _receivedOrders.clear();
    _receivedOrders = await Order().getOrdersByStatusId(statusId: '8');
    loadingNotDelivered = false;
    setState(() {});
  }

  @override
  void initState() {
    _getOrder();
    // TODO: implement initState
    getAllDeliveries();
    getAllEmployees();
    super.initState();
    tabcontroller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabcontroller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      indicatorColor: accentColor,
      labelStyle: TextStyle(fontSize: 18),
      tabs: <Tab>[
        Tab(
          text: 'جديد',
        ),
        Tab(
          text: 'لم تسلم',
        ),
        Tab(
          text: 'تم التسليم',
        ),
      ],
      controller: tabcontroller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      children: tabs,
      controller: tabcontroller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('المسؤول'),
        centerTitle: true,
        bottom: getTabBar(),
      ),
      body: connected
          ? getTabBarView(<Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  await getNewOrders().then((lA) {
                    return;
                  });
                },
                child: TabNewOrder(
                  order: _newOrders,
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await getNotDeliveredOrders().then((lA) {
                    return;
                  });
                },
                child: TabNotDelivered(
                  order: _notDeliveredOrders,
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await getReceivedOrders().then((lA) {
                    return;
                  });
                },
                child: TabReceived(
                  order: _receivedOrders,
                ),
              ),
            ])
          : notConnectedWidget(
              context: context,
              fun: () {
                //_checkUpdate();
              }),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/logo1.png'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserScreen()));
            },
            leading: Icon(
              Icons.group,
              color: mainColor,
            ),
            title: Text(
              "واجة المستخدمين",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllEmployeeScreen()));
            },
            leading: Icon(
              Icons.group,
              color: mainColor,
            ),
            title: Text(
              "موظفين",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllDeliveryScreen()));
            },
            leading: Icon(
              Icons.directions_bike,
              color: mainColor,
            ),
            title: Text(
              "دليفري",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllCategoriesScreen()));
            },
            leading: Icon(
              Icons.shopping_cart,
              color: mainColor,
            ),
            title: Text(
              "فئة",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SlidersScreen()));
            },
            leading: Icon(
              Icons.slideshow,
              color: mainColor,
            ),
            title: Text(
              "السليدر",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReportsScreen()));
            },
            leading: Icon(
              Icons.report,
              color: mainColor,
            ),
            title: Text(
              "الشكاوى",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          /*    ListTile(
            onTap: () {
              Navigator.pop(context);
              tabcontroller.animateTo(0);
            },
            leading: Icon(
              Icons.check,
              color: mainColor,
            ),
            title: Text(
              "تم التسليم",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              tabcontroller.animateTo(1);
            },
            leading: Icon(
              Icons.clear,
              color: mainColor,
            ),
            title: Text(
              "لم تسلم",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              tabcontroller.animateTo(2);
            },
            leading: Icon(
              Icons.transit_enterexit,
              color: mainColor,
            ),
            title: Text(
              "لم تستلم",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),*/
          ListTile(
            onTap: () {
              Navigator.pop(context);
              shareApp();
            },
            leading: Icon(
              Icons.share,
              color: mainColor,
            ),
            title: Text(
              "مشاركة التطبيق",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              if (await MySharedPreferences().isLogin()) {
                await MySharedPreferences().setLogout();
                check();
                globalUser = User();
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserScreen()));
            },
            leading: Icon(
              Icons.arrow_forward,
              color: mainColor,
            ),
            title: Text(
              "تسجيل الخروج",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
