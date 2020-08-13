import 'package:burgernook/database/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/models/user/basket.dart';
import 'package:burgernook/screens/loginData/loginScreen.dart';
import 'package:burgernook/screens/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'lang/LocaleHelper.dart';
import 'lang/app_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLocalizations appLocalizations = AppLocalizations(Locale("ar"));

  iniLang() async {
    Locale locale = await MySharedPreferences().getProviderLangSharedPref();
    print("locale.languageCode : ${locale.languageCode}");
    appLocalizations = AppLocalizations(locale);
    helper.onLocaleChanged(locale);
    this.setState(() {});
  }

  onLocaleChange(Locale locale) {
    setState(() {
      appLocalizations = AppLocalizations(locale);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helper.onLocaleChanged = onLocaleChange;
    iniLang();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Basket(),
        ),
      ],
      child: MaterialApp(
        supportedLocales: [
          Locale('ar'),
          Locale('en'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: appLocalizations.locale,
        routes: <String, WidgetBuilder>{
          "/": (context) => SplashScreen(),
          "/LoginScreen": (context) => LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Burger Nook',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black
              ),
                textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.black,
                  fontFamily: "GE_Dinar_One_Medium",
                  fontSize: 23),

            )),
            primarySwatch: Colors.amber,
            fontFamily: "GE_Dinar_One_Medium"),
        //home: SplashScreen(),
      ),
    );
  }
}
