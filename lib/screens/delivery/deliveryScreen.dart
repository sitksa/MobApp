import 'package:burgernook/lang/LocaleHelper.dart';
import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/screens/user/detailsOrder.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/database/sharedPreferences.dart';
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:burgernook/screens/user/userScreen.dart';
import 'package:burgernook/widgets/orderItem.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  List<Order> order = List();
  bool loading = true;

  getOrder() async {
    order.clear();
    setState(() {
      loading = true;
    });
    order = await Order().getAllOrdersByUserID();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        backgroundColor: mainColor,

        title: Text(appLocalizations.translate("Delivery")),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await getOrder().then((lA) {
              return;
            });
          },
          child: loading
              ? myCircularProgressIndicator()
              : order.isNotEmpty
                  ? ListView(
                      children: order.map((Order order) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsOrder(
                                      order: order,
                                    ))).then((value) {
                              if (value == true) {
                                getOrder();
                              }
                            });
                          },
                          child: OrderItem(
                            order: order,
                          ),
                        );
                      }).toList(),
                    )
                  : ListView(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 50),
                            child: emptyWidget()),
                      ],
                    )),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage("assets/bg_logo.png"),
              fit: BoxFit.fill,
            )),
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg_logo.png"),
                      fit: BoxFit.fill,
                    )),
                child: Image.asset('assets/logopng.png'),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);

                    },
                    leading: Image.asset(
                      "assets/home1.png",
                      height: 25,
                    ),
                    title: Text(AppLocalizations.of(context).translate("Home"),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),


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
                      AppLocalizations.of(context).translate("Share the app"),//   "مشاركة التطبيق",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),



                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      if (AppLocalizations.of(context).locale.languageCode ==
                          "en") {
                        helper.onLocaleChanged(new Locale("ar"));
                        await MySharedPreferences()
                            .saveProviderLangSharedPref(languageCode: "ar");
                      } else {
                        helper.onLocaleChanged(new Locale("en"));
                        await MySharedPreferences()
                            .saveProviderLangSharedPref(languageCode: "en");
                      }
                      setState(() {});
                    },
                    leading: Icon(
                      Icons.language,
                      color: mainColor,
                    ),
                    title: Text(
                      "${AppLocalizations.of(context).translate("lang")}",
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
                      "${AppLocalizations.of(context).translate("logout")}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/logo1.png'),
          ),
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
