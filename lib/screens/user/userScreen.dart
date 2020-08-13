import 'package:burgernook/lang/LocaleHelper.dart';
import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/screens/aboutUs.dart';
import 'package:burgernook/widgets/mySlider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/database/sharedPreferences.dart';
import 'package:burgernook/models/category.dart';
import 'package:burgernook/models/user/address.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:burgernook/screens/owner/ownerScreen.dart';
import 'package:burgernook/screens/user/basketScreen.dart';
import 'package:burgernook/screens/user/ordersScreen.dart';
import 'package:burgernook/screens/user/reportScreen.dart';
import 'package:burgernook/widgets/categoryWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Category> categories = List();
  List<Address> address = List();
  bool isLading = true;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  _getCategory() async {
    if (connected) {
      categories = await Category().fetchCategoryData();
      isLading = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
  }

  Future<Null> _refresh() async {
    setState(() {
      isLading = true;
    });
    await _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Basket>(context);
    return Scaffold(
      key: _globalKey,
      drawer: _drawer(),
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(15),
          child: InkWell(
            onTap: () {
              _globalKey.currentState.openDrawer();
            },
            child: Image.asset(
              "assets/menu.png",
            ),
          ),
        ),
        backgroundColor: mainColor,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BasketScreen()));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: basket.getOrderDetails().isNotEmpty
                  ? Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/basket1.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            curve: Curves.easeOutSine,
                            duration: Duration(milliseconds: 600),
                            width: basket.getWidthBasket(),
                            margin: EdgeInsets.only(bottom: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: basket.getColorBasket(),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${basket.getOrderDetails().length}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "arlrdbd",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Image.asset(
                      "assets/basket1.png",
                      height: 30,
                      width: 30,
                    ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: <Widget>[
            HomeSlider(),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: isLading
                  ? [
                      _ladingWidget(),
                      _ladingWidget(),
                      _ladingWidget(),
                    ]
                  : categories.map((Category category) {
                      return (category.products.isNotEmpty)
                          ? CategoryWidget(
                              category: category,
                            )
                          : Container();
                    }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ladingWidget2() {
    return CarouselSlider(
      items: [
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
      ],
      height: 200,
      // MediaQuery.of(context).size.height / 3.5,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _ladingWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: myCircularProgressIndicator(),
                          width: 150,
                          height: 100,
                        ),
                        Text(''),
                        Text(''),
                        Text(''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            isLogin &&
                    (globalUser.employeeJob == '1' ||
                        globalUser.employeeJob == '2')
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OwnerScreen()));
                    },
                    leading: Icon(
                      Icons.dashboard,
                      color: mainColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("Dashboard"),// "لوحة التحكم",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersScreen()));
                    },
                    leading: Image.asset(
                      "assets/basket.png",
                      height: 25,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("Follow Orders"),//"متابعة الطلبات",
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
                              builder: (context) => ReportScreen()));
                    },
                    leading: Icon(
                      Icons.report,
                      color: mainColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("Complaints"),//"الشكاوي",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()));
                    },
                    leading: Icon(
                      Icons.message,
                      color: mainColor,
                    ),
                    title: Text(
                     "${AppLocalizations.of(context).translate("about us")}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  isLogin
                      ? Container()
                      : ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/LoginScreen');
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: mainColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("login"),// "تسجيل الدخول",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  !isLogin
                      ? Container()
                      : ListTile(
                    onTap: () async {
                      if (await MySharedPreferences().isLogin()) {
                        await MySharedPreferences().setLogout();
                        await check();
                        globalUser = User();
                        setState(() {});
                      }
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.arrow_forward,
                      color: mainColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate("logout"),// "تسجيل الخروج",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
